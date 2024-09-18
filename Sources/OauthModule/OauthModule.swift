import FeatherComponent
import FeatherModuleKit
import Logging
import OauthModuleKit
import SystemModuleKit

public struct OauthModule: OauthModuleInterface {

    public let system: SystemModuleInterface
    let components: ComponentRegistry
    let logger: Logger

    public init(
        system: SystemModuleInterface,
        components: ComponentRegistry,
        logger: Logger = .init(label: "oauth-Module")
    ) {
        self.system = system
        self.components = components
        self.logger = logger
    }

    public var oauthFlow: OauthFlowInterface {
        OauthFlowController(
            components: components,
            oauth: self
        )
    }

    public var oauthClient: OauthClientInterface {
        OauthClientController(
            components: components,
            oauth: self
        )
    }

    public var oauthRole: OauthRoleInterface {
        OauthRoleController(
            components: components,
            oauth: self
        )
    }

    public var authorizationCode: AuthorizationCodeInterface {
        AuthorizationCodeController(
            components: components,
            oauth: self
        )
    }

}
