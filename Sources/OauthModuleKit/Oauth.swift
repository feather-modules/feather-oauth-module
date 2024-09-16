//
//  File.swift
//
//
//  Created by Viasz-Kádi Ferenc on 03/02/2024.
//

import FeatherACL
import FeatherModuleKit
import SystemModuleKit

extension Permission {

    static func oauth(_ context: String, action: Action) -> Self {
        .init(namespace: "oauth", context: context, action: action)
    }
}

public enum Oauth {

    public enum ACL: ACLSet {

        public static var all: [FeatherACL.Permission] {
            Client.ACL.all
            + Role.ACL.all
        }
    }

    public enum Error: Swift.Error {
        case invalidClient
        case invalidRedirectURI
        case invalidRequest
        case invalidScope
        case invalidGrant
        case unsupportedGrant
        case unauthorizedClient
        case emptyClientRole
    }

    public enum JWTError: Swift.Error {
        case jwtVerifyFailed
        case jwtUserError
    }

    public enum Flow: Identifiable {}
    public enum AuthorizationCode: Identifiable {}
    public enum Client: Identifiable {}
    public enum ClientRole {}
    public enum Role: Identifiable {}
    public enum RolePermission {}
}

public protocol OauthModuleInterface: ModuleInterface {

    var system: SystemModuleInterface { get }

    var authorizationCode: AuthorizationCodeInterface { get }
    var oauthFlow: OauthFlowInterface { get }
    var oauthClient: OauthClientInterface { get }
    var oauthRole: OauthRoleInterface { get }
}
