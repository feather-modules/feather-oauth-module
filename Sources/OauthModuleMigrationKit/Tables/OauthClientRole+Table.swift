import FeatherDatabase
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.ClientRole {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.clientId),
            StringColumn(Model.ColumnNames.roleKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint([
                Model.ColumnNames.clientId, Model.ColumnNames.roleKey,
            ])
        ]
    }

}
