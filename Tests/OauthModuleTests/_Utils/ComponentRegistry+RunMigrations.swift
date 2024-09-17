//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherScripts
import SystemModuleKit
import SystemModuleMigrationKit
import OauthModuleKit
import OauthModuleMigrationKit

extension ComponentRegistry {

    func runMigrations() async throws {

        let scripts = ScriptExecutor(
            components: self,
            policy: .runAll
        )

        try await scripts.execute([
            Oauth.Migrations.V1.self
        ])

        try await scripts.execute([
            System.Migrations.V1.self
        ])
    }
}
