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
import UserModuleKit
import UserModuleMigrationKit

extension ComponentRegistry {

    func runMigrations() async throws {

        let scripts = ScriptExecutor(
            components: self,
            policy: .runAll
        )

        try await scripts.execute([
            User.Migrations.V1.self
        ])

        try await scripts.execute([
            System.Migrations.V1.self
        ])
    }
}
