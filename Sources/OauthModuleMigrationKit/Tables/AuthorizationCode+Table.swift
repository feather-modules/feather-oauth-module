import FeatherDatabase
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.AuthorizationCode {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            DoubleColumn(Model.ColumnNames.expiration),
            StringColumn(Model.ColumnNames.value),
            StringColumn(Model.ColumnNames.userId),
            StringColumn(Model.ColumnNames.clientId),
            StringColumn(Model.ColumnNames.redirectUri),
            StringColumn(Model.ColumnNames.scope, isMandatory: false),
            StringColumn(Model.ColumnNames.state, isMandatory: false),
            StringColumn(Model.ColumnNames.codeChallenge, isMandatory: false),
            StringColumn(
                Model.ColumnNames.codeChallengeMethod,
                isMandatory: false
            ),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint([Model.ColumnNames.id])
        ]
    }

}
