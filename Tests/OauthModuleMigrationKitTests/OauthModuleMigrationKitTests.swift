import FeatherDatabase
import OauthModuleDatabaseKit
import OauthModuleKit
import SystemModuleDatabaseKit
import SystemModuleKit
import XCTest

@testable import UserModuleMigrationKit

final class OauthModuleMigrationKitTests: TestCase {

    func testSeedMigration() async throws {

        try await scripts.execute([
            Oauth.Migrations.V1.self
        ])
        try await scripts.execute([
            System.Migrations.V1.self
        ])

        let db = try await components.database().connection()

        try await Oauth.Client.Query
            .insert(
                .init(
                    id: NanoID.generateKey(),
                    email: "test@test.com",
                    password: "ChangeMe1"
                ),
                on: db
            )

    }
}
