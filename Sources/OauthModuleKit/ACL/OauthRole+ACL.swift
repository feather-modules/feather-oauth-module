//
//  File.swift
//
//  Created by gerp83 on 11/09/2024
//

import FeatherACL

extension Permission {

    static func oauthRole(_ action: Action) -> Self {
        .oauth("role", action: action)
    }
}

extension Oauth.Role {

    public enum ACL: ACLSet {

        public static let list: Permission = .oauthRole(.list)
        public static let detail: Permission = .oauthRole(.detail)
        public static let create: Permission = .oauthRole(.create)
        public static let update: Permission = .oauthRole(.update)
        public static let delete: Permission = .oauthRole(.delete)

        public static var all: [Permission] = [
            Self.list,
            Self.detail,
            Self.create,
            Self.update,
            Self.delete,
        ]
    }
}
