//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherACL

extension Permission {

    static func oauthClient(_ action: Action) -> Self {
        .oauth("client", action: action)
    }
}

extension Oauth.Client {

    public enum ACL: ACLSet {

        public static let list: Permission = .oauthClient(.list)
        public static let detail: Permission = .oauthClient(.detail)
        public static let create: Permission = .oauthClient(.create)
        public static let update: Permission = .oauthClient(.update)
        public static let delete: Permission = .oauthClient(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
