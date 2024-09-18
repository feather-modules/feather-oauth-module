//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.Client {

    public enum Table: DatabaseTable {
        public static let tableName = Model.tableName
        public static let columns: [DatabaseColumnInterface] = [
            StringColumn(Model.ColumnNames.id),
            StringColumn(Model.ColumnNames.name),
            StringColumn(Model.ColumnNames.type),
            StringColumn(Model.ColumnNames.clientSecret, isMandatory: false),
            StringColumn(Model.ColumnNames.redirectUri, isMandatory: false),
            StringColumn(
                Model.ColumnNames.loginRedirectUri,
                isMandatory: false
            ),
            StringColumn(Model.ColumnNames.issuer),
            StringColumn(Model.ColumnNames.audience),
            StringColumn(Model.ColumnNames.privateKey),
            StringColumn(Model.ColumnNames.publicKey),
        ]
        public static let constraints: [DatabaseConstraintInterface] = [
            UniqueConstraint(Model.ColumnNames.id),
            UniqueConstraint(Model.ColumnNames.name),
            UniqueConstraint(Model.ColumnNames.clientSecret),
            UniqueConstraint(Model.ColumnNames.privateKey),
            UniqueConstraint(Model.ColumnNames.publicKey),
        ]
    }

}
