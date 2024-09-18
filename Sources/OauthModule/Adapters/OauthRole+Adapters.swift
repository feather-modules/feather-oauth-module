import FeatherComponent
import FeatherModuleKit
import FeatherValidation
import NanoID
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth.Role.Model.ColumnNames: ListQuerySortKeyAdapter {
    public init(listQuerySortKeys: Oauth.Role.List.Query.Sort.Key) throws {
        switch listQuerySortKeys {
        case .key:
            self = .key
        case .name:
            self = .name
        }
    }
}

extension Oauth.Role.List.Item: ListItemAdapter {
    public init(model: Oauth.Role.Model) throws {
        self.init(
            key: model.key.toID(),
            name: model.name
        )
    }
}

extension Oauth.Role.List: ListAdapter {
    public typealias Model = Oauth.Role.Model
}

extension Oauth.Role.Reference: ReferenceAdapter {
    public init(model: Oauth.Role.Model) throws {
        self.init(
            key: model.key.toID(),
            name: model.name
        )
    }
}
