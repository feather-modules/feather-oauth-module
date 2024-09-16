import FeatherDatabase
import OauthModuleKit

extension Oauth.AuthorizationCode {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
