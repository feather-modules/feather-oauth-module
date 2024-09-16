//
//  File.swift
//
//  Created by gerp83 on 23/08/2024
//

import FeatherDatabase
import OauthModuleKit

extension Oauth.Client {

    public enum Query: DatabaseQuery {
        public typealias Row = Model
    }
}
