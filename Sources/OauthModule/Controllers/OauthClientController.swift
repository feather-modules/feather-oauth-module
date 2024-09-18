//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import Crypto
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import Logging
import NanoID
import OauthModuleKit

struct OauthClientController: OauthClientInterface,
    ControllerList,
    ControllerDelete,
    ControllerReference
{

    typealias Query = Oauth.Client.Query
    typealias Reference = Oauth.Client.Reference
    typealias List = Oauth.Client.List

    typealias ControllerModel = Oauth.Client

    let components: ComponentRegistry
    let oauth: OauthModuleInterface

    public init(
        components: ComponentRegistry,
        oauth: OauthModuleInterface
    ) {
        self.components = components
        self.oauth = oauth
    }

    // MARK: -

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .name,
            .type,
        ]

    func create(
        _ input: Oauth.Client.Create
    ) async throws -> Oauth.Client.Detail {
        let db = try await components.database().connection()

        let privateKeyData = Curve25519.Signing.PrivateKey()
        let privateKeyBase64 = privateKeyData.rawRepresentation
            .base64EncodedString()
        let publicKeyBase64 = privateKeyData.publicKey.rawRepresentation
            .base64EncodedString()
        var newClientSecret: String? = nil
        var newRedirectUri: String? = input.redirectUri
        var newLoginRedirectUri: String? = input.loginRedirectUri

        if input.type == .server {
            newClientSecret = .generateToken(32)
            newRedirectUri = nil
            newLoginRedirectUri = nil
            if input.roleKeys == nil || input.roleKeys!.isEmpty {
                throw Oauth.Error.emptyClientRole
            }
        }

        let model = Oauth.Client.Model(
            id: NanoID.generateKey(),
            name: input.name,
            type: input.type.rawValue,
            clientSecret: newClientSecret,
            redirectUri: newRedirectUri,
            loginRedirectUri: newLoginRedirectUri,
            issuer: input.issuer,
            audience: input.audience,
            privateKey: privateKeyBase64,
            publicKey: publicKeyBase64
        )

        if let roleKeys = input.roleKeys {
            try await updateClientRoles(
                model.id.toID(),
                roleKeys,
                db
            )
        }

        try await input.validate(on: db)
        try await Oauth.Client.Query.insert(model, on: db)
        return try await getClientBy(clientId: model.id.toID(), db)
    }

    func require(
        _ id: ID<Oauth.Client>
    ) async throws -> Oauth.Client.Detail {
        let db = try await components.database().connection()
        return try await getClientBy(clientId: id, db)
    }

    func update(
        _ id: ID<Oauth.Client>,
        _ input: Oauth.Client.Update
    ) async throws -> Oauth.Client.Detail {
        let db = try await components.database().connection()

        let detail = try await Oauth.Client.Query.require(
            id.toKey(),
            on: db
        )
        try await input.validate(detail.name, on: db)
        if input.type == .server
            && (input.roleKeys == nil || input.roleKeys!.isEmpty)
        {
            throw Oauth.Error.emptyClientRole
        }

        let newModel = Oauth.Client.Model(
            id: detail.id,
            name: input.name,
            type: input.type.rawValue,
            clientSecret: detail.clientSecret,
            redirectUri: input.redirectUri,
            loginRedirectUri: input.loginRedirectUri,
            issuer: input.issuer,
            audience: input.audience,
            privateKey: detail.privateKey,
            publicKey: detail.publicKey
        )
        try await Oauth.Client.Query.update(id.toKey(), newModel, on: db)
        if let roleKeys = input.roleKeys {
            try await updateClientRoles(
                newModel.id.toID(),
                roleKeys,
                db
            )
        }
        return try await getClientBy(clientId: newModel.id.toID(), db)
    }

    func patch(
        _ id: ID<Oauth.Client>,
        _ input: Oauth.Client.Patch
    ) async throws -> Oauth.Client.Detail {
        let db = try await components.database().connection()

        let oldModel = try await Oauth.Client.Query.require(
            id.toKey(),
            on: db
        )
        try await input.validate(oldModel.name, on: db)
        if input.type == .server
            && (input.roleKeys == nil || input.roleKeys!.isEmpty)
        {
            throw Oauth.Error.emptyClientRole
        }

        let newModel = Oauth.Client.Model(
            id: oldModel.id,
            name: input.name ?? oldModel.name,
            type: input.type?.rawValue ?? oldModel.type,
            clientSecret: oldModel.clientSecret,
            redirectUri: input.redirectUri ?? oldModel.redirectUri,
            loginRedirectUri: input.loginRedirectUri
                ?? oldModel.loginRedirectUri,
            issuer: input.issuer ?? oldModel.issuer,
            audience: input.audience ?? oldModel.audience,
            privateKey: oldModel.privateKey,
            publicKey: oldModel.publicKey
        )
        try await Oauth.Client.Query.update(id.toKey(), newModel, on: db)

        if let roleKeys = input.roleKeys {
            try await updateClientRoles(
                newModel.id.toID(),
                roleKeys,
                db
            )
        }
        return try await getClientBy(clientId: id, db)
    }

}

extension OauthClientController {

    fileprivate func getClientBy(
        clientId: ID<Oauth.Client>,
        _ db: Database
    ) async throws -> Oauth.Client.Detail {
        guard
            let model = try await Oauth.Client.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .is,
                    value: clientId
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: Oauth.Client.Model.self),
                keyName: Oauth.Client.Model.keyName.rawValue
            )
        }
        let roleKeys = try await Oauth.ClientRole.Query
            .listAll(
                filter: .init(
                    column: .clientId,
                    operator: .equal,
                    value: clientId
                ),
                on: db
            )
            .map { $0.roleKey }
            .map { $0.toID() }
        let roles = try await oauth.oauthRole.reference(ids: roleKeys)

        return Oauth.Client.Detail(
            id: model.id.toID(),
            name: model.name,
            type: Oauth.Client.ClientType.init(rawValue: model.type)!,
            clientSecret: model.clientSecret,
            redirectUri: model.redirectUri,
            loginRedirectUri: model.loginRedirectUri,
            issuer: model.issuer,
            audience: model.audience,
            privateKey: model.privateKey,
            publicKey: model.publicKey,
            roles: roles
        )
    }

    fileprivate func updateClientRoles(
        _ clientId: ID<Oauth.Client>,
        _ roleKeys: [ID<Oauth.Role>],
        _ db: Database
    ) async throws {
        let roles = try await oauth.oauthRole.reference(ids: roleKeys)
        try await Oauth.ClientRole.Query.delete(
            filter: .init(
                column: .clientId,
                operator: .equal,
                value: clientId
            ),
            on: db
        )
        try await Oauth.ClientRole.Query.insert(
            roles.map {
                Oauth.ClientRole.Model(
                    clientId: clientId.toKey(),
                    roleKey: $0.key.toKey()
                )
            },
            on: db
        )
    }

}
