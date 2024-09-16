//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import OauthModuleKit

extension Oauth.Client {

    public struct Model: KeyedDatabaseModel {

        public typealias KeyType = Key<Oauth.Client>

        public enum CodingKeys: String, DatabaseColumnName {
            case id
            case name
            case type
            case clientSecret = "client_secret"
            case redirectUri = "redirect_uri"
            case loginRedirectUri = "login_redirect_uri"
            case issuer
            case audience
            case privateKey = "private_key"
            case publicKey = "public_key"
        }

        public static let tableName = "oauth_client"
        public static let columnNames = CodingKeys.self
        public static let keyName = Model.ColumnNames.id

        public let id: KeyType
        public let name: String
        public let type: String
        public let clientSecret: String?
        public let redirectUri: String?
        public let loginRedirectUri: String?
        public let issuer: String
        public let audience: String
        public let privateKey: String
        public let publicKey: String

        public init(
            id: KeyType,
            name: String,
            type: String,
            clientSecret: String?,
            redirectUri: String?,
            loginRedirectUri: String?,
            issuer: String,
            audience: String,
            privateKey: String,
            publicKey: String
        ) {
            self.id = id
            self.name = name
            self.type = type
            self.clientSecret = clientSecret
            self.redirectUri = redirectUri
            self.loginRedirectUri = loginRedirectUri
            self.issuer = issuer
            self.audience = audience
            self.privateKey = privateKey
            self.publicKey = publicKey
        }
    }
}
