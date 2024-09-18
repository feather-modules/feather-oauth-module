import FeatherDatabase
import OauthModuleKit
import SystemModuleKit

extension Oauth.RolePermission {

    public struct Model: DatabaseModel {

        public enum CodingKeys: String, DatabaseColumnName {
            case roleKey = "role_key"
            case permissionKey = "permission_key"
        }
        public static let tableName = "oauth_role_permission"
        public static let columnNames = CodingKeys.self

        public let roleKey: Key<Oauth.Role>
        public let permissionKey: Key<System.Permission>

        public init(
            roleKey: Key<Oauth.Role>,
            permissionKey: Key<System.Permission>
        ) {
            self.roleKey = roleKey
            self.permissionKey = permissionKey
        }
    }

}
