import FeatherDatabase
import OauthModuleKit

extension Oauth.Role {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
