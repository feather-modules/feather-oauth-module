import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import JWTKit
import Logging
import NanoID
import OauthModuleKit

struct OauthFlowController: OauthFlowInterface {

    let components: ComponentRegistry
    let oauth: OauthModuleInterface

    public init(
        components: ComponentRegistry,
        oauth: OauthModuleInterface
    ) {
        self.components = components
        self.oauth = oauth
    }

    func check(
        _ grantType: Oauth.Flow.FlowType?,
        _ clientId: String,
        _ clientSecret: String?,
        _ redirectUri: String?,
        _ scope: String? = nil
    ) async throws -> String? {
        let db = try await components.database().connection()
        guard
            let oauthClient = try await Oauth.Client.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: clientId
                ),
                on: db
            )
        else {
            throw Oauth.Error.invalidClient
        }

        // TODO: bettor scope handling/check

        if grantType == .clientCredentials {
            if oauthClient.clientSecret != clientSecret {
                throw Oauth.Error.invalidClient
            }
            if scope != "server" {
                throw Oauth.Error.invalidScope
            }

        }
        else {
            if oauthClient.redirectUri != redirectUri {
                throw Oauth.Error.invalidRedirectURI
            }

        }

        // exchange
        if grantType == nil && scope != "profile" {
            throw Oauth.Error.invalidScope
        }
        return oauthClient.loginRedirectUri
    }

    func getCode(_ request: Oauth.Flow.AuthorizationPostRequest) async throws
        -> String
    {
        
        // check if userId is empty
        if request.userId.isEmpty {
            throw Oauth.Error.unauthorizedClient
        }
        
        // create and save new code
        let detail = try await oauth.authorizationCode.create(
            .init(
                userId: request.userId,
                clientId: request.clientId,
                redirectUri: request.redirectUri,
                scope: request.scope,
                state: request.state
            )
        )

        return detail.value
    }

    func getJWT(_ request: Oauth.Flow.JwtRequest, userData: Oauth.Flow.UserData? = nil) async throws
        -> Oauth.Flow.JwtResponse
    {
        let db = try await components.database().connection()
        let interval = 604800

        // check if client exist in db
        guard
            let oauthClient = try await Oauth.Client.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .equal,
                    value: request.clientId
                ),
                on: db
            )
        else {
            throw Oauth.Error.unauthorizedClient
        }
        let kid = JWKIdentifier(string: oauthClient.id.rawValue)
        let privateKeyBase64 = oauthClient.privateKey

        // code exchange
        guard request.grantType == .authorization else {

            // create jwt
            let keyCollection = try await getKeyCollection(
                privateKeyBase64,
                kid
            )
            let payload = Oauth.Flow.Payload(
                iss: IssuerClaim(value: oauthClient.issuer),
                aud: AudienceClaim(value: oauthClient.audience),
                // 1 week
                exp: ExpirationClaim(
                    value: Date().addingTimeInterval(TimeInterval(interval))
                )
            )
            let jwt = try await keyCollection.sign(payload, kid: kid)

            return .init(
                accessToken: jwt,
                tokenType: "Bearer",
                expiresIn: interval,
                scope: "server"
            )
        }

        // check if code exist in db
        guard
            let authorizationCode = try await Oauth.AuthorizationCode.Query
                .getFirst(
                    filter: .init(
                        column: .value,
                        operator: .equal,
                        value: request.code
                    ),
                    on: db
                )
        else {
            throw Oauth.Error.invalidGrant
        }

        // validate code, delete it if error
        if !validateCode(
            authorizationCode,
            request.clientId,
            request.redirectUri
        ) {
            try await deleteCode(authorizationCode.value, db)
            throw Oauth.Error.invalidGrant
        }

        // delete code so it can not be used again
        try await deleteCode(authorizationCode.value, db)

        // create jwt
        let keyCollection = try await getKeyCollection(privateKeyBase64, kid)
        
        
        let payload = Oauth.Flow.Payload(
            iss: IssuerClaim(value: oauthClient.issuer),
            sub: SubjectClaim(value: authorizationCode.userId),
            aud: AudienceClaim(value: oauthClient.audience),
            // 1 week
            exp: ExpirationClaim(
                value: Date().addingTimeInterval(TimeInterval(interval))
            ),
            roles: userData?.roles,
            permissions: userData?.permissions
        )
        let jwt = try await keyCollection.sign(payload, kid: kid)

        return .init(
            accessToken: jwt,
            tokenType: "Bearer",
            expiresIn: interval,
            scope: "profile"
        )
    }

    private func getKeyCollection(
        _ privateKeyBase64: String,
        _ kid: JWKIdentifier
    )
        async throws -> JWTKeyCollection
    {
        let privateKey = try EdDSA.PrivateKey(
            d: privateKeyBase64,
            curve: .ed25519
        )
        return await JWTKeyCollection()
            .add(
                eddsa: privateKey,
                kid: kid
            )
    }

    private func deleteCode(_ code: String, _ db: Database) async throws {
        try await Oauth.AuthorizationCode.Query.delete(
            filter: .init(
                column: .value,
                operator: .equal,
                value: code
            ),
            on: db
        )
    }

    // valides a code before exchange
    private func validateCode(
        _ code: Oauth.AuthorizationCode.Model,
        _ clientId: String,
        _ redirectUri: String?
    ) -> Bool {
        if code.clientId != clientId {
            return false
        }
        else if code.redirectUri != redirectUri {
            return false
        }
        else if code.expiration < Date() {
            return false
        }
        return true
    }

}
