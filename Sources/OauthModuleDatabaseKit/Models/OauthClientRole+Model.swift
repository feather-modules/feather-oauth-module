import FeatherDatabase
import OauthModuleKit

extension Oauth.ClientRole {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<Oauth.Client>

        public enum CodingKeys: String, DatabaseColumnName {
            case clientId = "client_id"
            case roleKey = "role_key"
        }
        public static let tableName = "oauth_client_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.clientId

        public let clientId: KeyType
        public let roleKey: Key<Oauth.Role>

        public init(clientId: KeyType, roleKey: Key<Oauth.Role>) {
            self.clientId = clientId
            self.roleKey = roleKey
        }
    }
}
