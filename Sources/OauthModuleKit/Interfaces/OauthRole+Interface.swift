//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//

import FeatherModuleKit
import SystemModuleKit

public protocol OauthRoleInterface: Sendable {

    func list(
        _ input: Oauth.Role.List.Query
    ) async throws -> Oauth.Role.List

    func reference(
        ids: [ID<Oauth.Role>]
    ) async throws -> [Oauth.Role.Reference]

    func create(
        _ input: Oauth.Role.Create
    ) async throws -> Oauth.Role.Detail

    func require(
        _ id: ID<Oauth.Role>
    ) async throws -> Oauth.Role.Detail

    func update(
        _ id: ID<Oauth.Role>,
        _ input: Oauth.Role.Update
    ) async throws -> Oauth.Role.Detail

    func patch(
        _ id: ID<Oauth.Role>,
        _ input: Oauth.Role.Patch
    ) async throws -> Oauth.Role.Detail

    func bulkDelete(
        ids: [ID<Oauth.Role>]
    ) async throws

    func getPermissionsKeys(
        _ roleKeys: [ID<Oauth.Role>]
    ) async throws -> [ID<System.Permission>]

}
