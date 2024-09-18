import FeatherDatabase
import Foundation
import OauthModuleKit

extension Oauth.AuthorizationCode {

    public struct Model: DatabaseModel {

        public typealias KeyType = Key<Oauth.AuthorizationCode>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case expiration
            case value
            case userId = "user_id"
            case clientId = "client_id"
            case redirectUri = "redirect_uri"
            case scope
            case state
            case codeChallenge = "code_challenge"
            case codeChallengeMethod = "code_challenge_method"
        }

        public static let tableName = "oauth_authorization_code"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
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
            id: KeyType,
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

}
