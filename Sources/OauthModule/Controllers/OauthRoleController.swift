//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//

import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import Logging
import SystemModuleKit
import OauthModuleKit

struct OauthRoleController: OauthRoleInterface,
    ControllerDelete,
    ControllerList,
    ControllerReference
{

    typealias Query = Oauth.Role.Query
    typealias Reference = Oauth.Role.Reference
    typealias List = Oauth.Role.List

    let components: ComponentRegistry
    let oauth: OauthModuleInterface

    public init(
        components: ComponentRegistry,
        oauth: OauthModuleInterface
    ) {
        self.components = components
        self.oauth = oauth
    }

    static let listFilterColumns: [Model.ColumnNames] =
        [
            .key, .name,
        ]

    func create(_ input: Oauth.Role.Create) async throws -> Oauth.Role.Detail
    {
        let db = try await components.database().connection()
        try await input.validate(on: db)

        let model = Oauth.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )

        try await Oauth.Role.Query.insert(model, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            input.key,
            db
        )
        return try await getRoleBy(id: model.key.toID(), db)
    }

    func require(_ id: ID<Oauth.Role>) async throws -> Oauth.Role.Detail
    {
        let db = try await components.database().connection()
        return try await getRoleBy(id: id, db)
    }

    func update(
        _ id: ID<Oauth.Role>,
        _ input: Oauth.Role.Update
    ) async throws -> Oauth.Role.Detail {
        let db = try await components.database().connection()

        try await Oauth.Role.Query.require(id.toKey(), on: db)
        try await input.validate(id, on: db)

        let newModel = Oauth.Role.Model(
            key: input.key.toKey(),
            name: input.name,
            notes: input.notes
        )

        try await Oauth.Role.Query.update(id.toKey(), newModel, on: db)
        try await updateRolePermissions(
            input.permissionKeys,
            newModel.key.toID(),
            db
        )
        return try await getRoleBy(id: newModel.key.toID(), db)
    }

    func patch(
        _ id: ID<Oauth.Role>,
        _ input: Oauth.Role.Patch
    ) async throws -> Oauth.Role.Detail {
        let db = try await components.database().connection()
        let oldModel = try await Oauth.Role.Query.require(
            id.toKey(),
            on: db
        )

        try await input.validate(id, on: db)
        let newModel = Oauth.Role.Model(
            key: input.key?.toKey() ?? oldModel.key,
            name: input.name ?? oldModel.name,
            notes: input.notes ?? oldModel.notes
        )
        try await Oauth.Role.Query.update(id.toKey(), newModel, on: db)
        if let permissionKeys = input.permissionKeys {
            try await updateRolePermissions(
                permissionKeys,
                newModel.key.toID(),
                db
            )
        }
        return try await getRoleBy(id: newModel.key.toID(), db)
    }

    private func getRoleBy(
        id: ID<Oauth.Role>,
        _ db: Database
    ) async throws -> Oauth.Role.Detail {
        let model = try await Oauth.Role.Query.require(id.toKey(), on: db)

        let permissionKeys = try await Oauth.RolePermission.Query
            .listAll(
                filter: .init(
                    column: .roleKey,
                    operator: .equal,
                    value: id
                ),
                on: db
            )
            .map { $0.permissionKey }
            .map { $0.toID() }

        let permissions = try await oauth.system.permission.reference(
            ids: permissionKeys
        )

        return Oauth.Role.Detail(
            key: model.key.toID(),
            name: model.name,
            notes: model.notes,
            permissions: permissions
        )
    }

    private func updateRolePermissions(
        _ permissionKeys: [ID<System.Permission>],
        _ role: ID<Oauth.Role>,
        _ db: Database
    ) async throws {
        try await Oauth.Role.Query.require(role.toKey(), on: db)

        let permissions = try await oauth.system.permission.reference(
            ids: permissionKeys
        )
        try await Oauth.RolePermission.Query.delete(
            filter: .init(
                column: .roleKey,
                operator: .equal,
                value: role
            ),
            on: db
        )
        try await Oauth.RolePermission.Query
            .insert(
                permissions.map {
                    Oauth.RolePermission.Model(
                        roleKey: role.toKey(),
                        permissionKey: $0.key.toKey()
                    )
                },
                on: db
            )
    }

    func getPermissionsKeys(_ roleKeys: [ID<Oauth.Role>]) async throws
        -> [ID<System.Permission>]
    {
        let db = try await components.database().connection()
        return try await Oauth.RolePermission.Query
            .listAll(
                filter: .init(
                    column: .roleKey,
                    operator: .in,
                    value: roleKeys
                ),
                on: db
            )
            .map { $0.permissionKey }
            .map { $0.toID() }
    }

}
