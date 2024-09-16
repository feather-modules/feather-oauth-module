import FeatherDatabase
import OauthModuleKit

extension Oauth.RolePermission {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
