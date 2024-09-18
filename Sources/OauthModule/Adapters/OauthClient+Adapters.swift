//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.Client.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: Oauth.Client.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .name:
            self = .name
        case .type:
            self = .type
        }
    }
}

extension Oauth.Client.List.Item: ListItemAdapter {
    public init(model: Oauth.Client.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name,
            type: Oauth.Client.ClientType(rawValue: model.type)!
        )
    }
}

extension Oauth.Client.List: ListAdapter {
    public typealias Model = Oauth.Client.Model
}

extension Oauth.Client.Reference: ReferenceAdapter {
    public init(model: Oauth.Client.Model) throws {
        self.init(
            id: model.id.toID(),
            name: model.name,
            type: Oauth.Client.ClientType(rawValue: model.type)!
        )
    }
}
