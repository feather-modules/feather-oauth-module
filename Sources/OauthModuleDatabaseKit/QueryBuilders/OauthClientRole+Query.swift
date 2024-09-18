import FeatherDatabase
import OauthModuleKit

extension Oauth.ClientRole {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
