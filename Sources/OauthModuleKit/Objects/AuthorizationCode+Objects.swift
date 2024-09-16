import FeatherModuleKit
import Foundation

extension Oauth.AuthorizationCode {

    public struct Detail: Object {
        public let id: ID<Oauth.AuthorizationCode>
        public let expiration: Date
        public let value: String
        public let userId: String
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let codeChallenge: String?
        public let codeChallengeMethod: String?

        public init(
            id: ID<Oauth.AuthorizationCode>,
            expiration: Date,
            value: String,
            userId: String,
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            codeChallenge: String? = nil,
            codeChallengeMethod: String? = nil
        ) {
            self.id = id
            self.expiration = expiration
            self.value = value
            self.userId = userId
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }
    }

    public struct Create: Object {
        public let userId: String
        public let clientId: String
        public let redirectUri: String
        public let scope: String?
        public let state: String?
        public let codeChallenge: String?
        public let codeChallengeMethod: String?

        public init(
            userId: String,
            clientId: String,
            redirectUri: String,
            scope: String?,
            state: String?,
            codeChallenge: String? = nil,
            codeChallengeMethod: String? = nil
        ) {
            self.userId = userId
            self.clientId = clientId
            self.redirectUri = redirectUri
            self.scope = scope
            self.state = state
            self.codeChallenge = codeChallenge
            self.codeChallengeMethod = codeChallengeMethod
        }

    }

}
