import FeatherDatabase
import FeatherModuleKit
import FeatherValidation
import OauthModuleKit

extension Oauth.Client {

    enum Validators {
        static func checkLength(
            _ key: Model.CodingKeys,
            _ value: String
        ) -> Validator {
            KeyValueValidator(
                key: key.rawValue,
                value: value,
                rules: [
                    .min(length: 3),
                    .max(length: 64),
                ]
            )
        }

        static func uniqueKey(
            _ key: Model.CodingKeys,
            _ value: String,
            _ originalValue: String? = nil,
            on db: Database
        ) -> Validator {
            KeyValueValidator(
                key: key.rawValue,
                value: value,
                rules: [
                    .unique(
                        Query.self,
                        column: key,
                        originalValue: originalValue,
                        on: db
                    )
                ]
            )
        }
    }
}

extension Oauth.Client.Create {

    func validate(on db: Database) async throws {
        let v = GroupValidator {
            Oauth.Client.Validators.checkLength(.name, name)
            Oauth.Client.Validators.uniqueKey(.name, name, on: db)
            Oauth.Client.Validators.checkLength(.type, type.rawValue)
            Oauth.Client.Validators.checkLength(.issuer, issuer)
            Oauth.Client.Validators.checkLength(.audience, audience)
        }
        try await v.validate()
    }

}

extension Oauth.Client.Update {

    func validate(
        _ originalName: String,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            Oauth.Client.Validators.checkLength(.name, name)
            Oauth.Client.Validators.uniqueKey(
                .name,
                name,
                originalName,
                on: db
            )
            Oauth.Client.Validators.checkLength(.type, type.rawValue)
            Oauth.Client.Validators.checkLength(.issuer, issuer)
            Oauth.Client.Validators.checkLength(.audience, audience)
        }
        try await v.validate()
    }
}

extension Oauth.Client.Patch {

    func validate(
        _ originalName: String?,
        on db: Database
    ) async throws {
        let v = GroupValidator {
            if let name {
                Oauth.Client.Validators.checkLength(.name, name)
                Oauth.Client.Validators.uniqueKey(
                    .name,
                    name,
                    originalName,
                    on: db
                )
            }
            if let type {
                Oauth.Client.Validators.checkLength(.type, type.rawValue)
            }
            if let redirectUri {
                Oauth.Client.Validators.checkLength(
                    .redirectUri,
                    redirectUri
                )
            }
            if let issuer {
                Oauth.Client.Validators.checkLength(.issuer, issuer)
            }
            if let audience {
                Oauth.Client.Validators.checkLength(.audience, audience)
            }
        }
        try await v.validate()
    }
}
