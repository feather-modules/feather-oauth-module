import FeatherDatabase
import OauthModuleKit

extension Oauth.Role {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<Oauth.Role>

        public enum CodingKeys: String, DatabaseColumnName {
            case key
            case name
            case notes
        }
        public static let tableName = "oauth_role"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.key

        public let key: KeyType
        public let name: String
        public let notes: String?

        public init(
            key: KeyType,
            name: String,
            notes: String? = nil
        ) {
            self.key = key
            self.name = name
            self.notes = notes
        }
    }
}
