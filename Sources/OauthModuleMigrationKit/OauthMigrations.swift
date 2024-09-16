import FeatherComponent
import FeatherDatabase
import FeatherScripts
import OauthModuleDatabaseKit
import OauthModuleKit

extension Oauth {

    public enum Migrations {

        public enum V1: Script {

            public static func run(
                _ components: ComponentRegistry
            ) async throws {
                let db = try await components.database().connection()

                try await AuthorizationCode.Table.create(on: db)
                try await Client.Table.create(on: db)
                try await ClientRole.Table.create(on: db)
                try await Role.Table.create(on: db)
                try await RolePermission.Table.create(on: db)
            }
        }
    }

}
