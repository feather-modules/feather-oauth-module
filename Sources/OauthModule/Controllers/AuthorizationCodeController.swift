//
//  File.swift
//
//  Created by gerp83 on 17/08/2024
//

import FeatherACL
import FeatherComponent
import FeatherDatabase
import FeatherModuleKit
import Foundation
import NanoID
import SQLKit
import OauthModuleKit

struct AuthorizationCodeController: AuthorizationCodeInterface {

    let components: ComponentRegistry
    let oauth: OauthModuleInterface

    public init(
        components: ComponentRegistry,
        oauth: OauthModuleInterface
    ) {
        self.components = components
        self.oauth = oauth
    }

    func create(_ input: Oauth.AuthorizationCode.Create) async throws
        -> Oauth.AuthorizationCode.Detail
    {
        let db = try await components.database().connection()
        let newCode = String.generateToken()
        let model = Oauth.AuthorizationCode.Model(
            id: NanoID.generateKey(),
            expiration: Date().addingTimeInterval(600),
            value: newCode,
            userId: input.userId,
            clientId: input.clientId,
            redirectUri: input.redirectUri,
            scope: input.scope,
            state: input.state,
            codeChallenge: input.codeChallenge,
            codeChallengeMethod: input.codeChallengeMethod
        )
        try await Oauth.AuthorizationCode.Query.insert(model, on: db)
        return model.toDetail()
    }

    func require(_ id: ID<Oauth.AuthorizationCode>) async throws
        -> Oauth.AuthorizationCode.Detail
    {
        let db = try await components.database().connection()
        guard
            let model = try await Oauth.AuthorizationCode.Query.getFirst(
                filter: .init(
                    column: .id,
                    operator: .is,
                    value: id
                ),
                on: db
            )
        else {
            throw ModuleError.objectNotFound(
                model: String(reflecting: Oauth.AuthorizationCode.Model.self),
                keyName: Oauth.AuthorizationCode.Model.keyName.rawValue
            )
        }
        return model.toDetail()
    }

}

extension Oauth.AuthorizationCode.Model {

    func toDetail() -> Oauth.AuthorizationCode.Detail {
        Oauth.AuthorizationCode.Detail(
            id: self.id.toID(),
            expiration: self.expiration,
            value: self.value,
            userId: self.userId,
            clientId: self.clientId,
            redirectUri: self.redirectUri,
            scope: self.scope,
            state: self.state,
            codeChallenge: self.codeChallenge,
            codeChallengeMethod: self.codeChallengeMethod
        )
    }

}

extension String {

    public static func generateToken(_ length: Int = 64) -> String {
        let letters =
            "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
