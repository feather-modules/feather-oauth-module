//
//  File.swift
//
//
//  Created by gerp83 on 23/08/2024
//

import FeatherModuleKit

public protocol OauthClientInterface: Sendable {

    func list(
        _ input: Oauth.Client.List.Query
    ) async throws -> Oauth.Client.List

    func reference(
        ids: [ID<Oauth.Client>]
    ) async throws -> [Oauth.Client.Reference]

    func create(
        _ input: Oauth.Client.Create
    ) async throws -> Oauth.Client.Detail

    func require(
        _ id: ID<Oauth.Client>
    ) async throws -> Oauth.Client.Detail

    func update(
        _ id: ID<Oauth.Client>,
        _ input: Oauth.Client.Update
    ) async throws -> Oauth.Client.Detail

    func patch(
        _ id: ID<Oauth.Client>,
        _ input: Oauth.Client.Patch
    ) async throws -> Oauth.Client.Detail

    func bulkDelete(
        ids: [ID<Oauth.Client>]
    ) async throws
}
