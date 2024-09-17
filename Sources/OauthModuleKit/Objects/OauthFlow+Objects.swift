import FeatherModuleKit
import Foundation
import JWTKit

extension Oauth.Flow {

    public enum FlowType: String, Object, CaseIterable {
        case authorization = "authorization_code"
        case clientCredentials = "client_credentials"
    }
    
    public struct UserData {
        public var roles: [String]
        public var permissions: [String]
        
        public init(
            roles: [String],
            permissions: [String]
        ) {
           
            self.roles = roles
            self.permissions = permissions
        }
    }
    

    public struct Payload: JWTPayload, Equatable {
        public var iss: IssuerClaim
        public var sub: SubjectClaim?
        public var aud: AudienceClaim
        public var exp: ExpirationClaim
        public var roles: [String]?
        public var permissions: [String]?

        public init(
            iss: IssuerClaim,
            sub: SubjectClaim? = nil,
            aud: AudienceClaim,
            exp: ExpirationClaim,
            roles: [String]? = nil,
            permissions: [String]? = nil
        ) {
            self.iss = iss
            self.sub = sub
            self.aud = aud
            self.exp = exp
            self.roles = roles
            self.permissions = permissions
        }

        public func verify(using algorithm: some JWTKit.JWTAlgorithm)
            async throws
        {
            try self.exp.verifyNotExpired()
        }
    }

    public struct AuthorizationGetRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String?

        public init(
            clientId: String,
            redirectUri: String,
            scope: String?
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
        }

    }

    public struct AuthorizationPostRequest: Object {
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let userId: String

        public init(
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            userId: String
        ) {
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.userId = userId
        }
    }

    public struct JwtRequest: Object {
        public let grantType: FlowType?
        public let clientId: String
        public let clientSecret: String?
        public let code: String?
        public let redirectUri: String?
        public let scope: String?

        public init(
            grantType: FlowType?,
            clientId: String,
            clientSecret: String?,
            code: String?,
            redirectUri: String?,
            scope: String?
        ) {
            self.grantType = grantType
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.code = code
            self.redirectUri = redirectUri
            self.scope = scope
        }
    }

    public struct JwtResponse: Object {
        public let accessToken: String
        public let tokenType: String
        public let expiresIn: Int
        public let scope: String

        public init(
            accessToken: String,
            tokenType: String,
            expiresIn: Int,
            scope: String
        ) {
            self.accessToken = accessToken
            self.tokenType = tokenType
            self.expiresIn = expiresIn
            self.scope = scope
        }
    }

}
