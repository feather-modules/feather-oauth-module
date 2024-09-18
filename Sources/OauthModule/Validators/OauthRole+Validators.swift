import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import OauthModuleKit

extension Oauth.Role {

    enum Validators {

        static func uniqueKey(
            _ value: ID<Oauth.Role>,
            on db: Database,
            _ originalKey: ID<Oauth.Role>? = nil
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: .key,
                        originalValue: originalKey,
                        on: db
                    )
                ]
            )
        }

        static func key(
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: "key",
                value: value,
                rules: [
                    .nonempty(),
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }
    }
}

extension Oauth.Role.Create {

    func validate(
        on db: Database
    ) async throws {
        let v = GroupValidator {
            Oauth.Role.Validators.key(key.rawValue)
            Oauth.Role.Validators.uniqueKey(key, on: db)
        }
        try await v.validate()
    }
}

extension Oauth.Role.Update {

    func validate(
        _ originalKey: ID<Oauth.Role>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            Oauth.Role.Validators.key(key.rawValue)
            Oauth.Role.Validators.uniqueKey(
                key,
                on: db,
                originalKey
            )
        }
        try await v.validate()
    }
}

extension Oauth.Role.Patch {

    func validate(
        _ originalKey: ID<Oauth.Role>,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let key {
                Oauth.Role.Validators.key(key.rawValue)
                Oauth.Role.Validators.uniqueKey(
                    key,
                    on: db,
                    originalKey
                )
            }
        }
        try await v.validate()
    }
}
