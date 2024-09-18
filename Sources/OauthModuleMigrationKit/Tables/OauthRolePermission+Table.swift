import FeatherDatabase
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.RolePermission {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.roleKey),
            StringColumn(Model.ColumnNames.permissionKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(
                [
                    Model.ColumnNames.roleKey,
                    Model.ColumnNames.permissionKey,
                ]
            )
        ]
    }

}
