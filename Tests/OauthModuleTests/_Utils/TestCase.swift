//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherModuleKit
import NIO
import SystemModule
import OauthModule
import OauthModuleKit
import OauthModuleMigrationKit
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var module: OauthModuleInterface!

    override func setUp() async throws {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        components = ComponentRegistry()

        let system = SystemModule(components: components)
        module = OauthModule(system: system, components: components)

        try await components.configure(.singleton, eventLoopGroup)
        try await components.runMigrations()
    }

    override func tearDown() async throws {
        try await self.eventLoopGroup.shutdownGracefully()
    }
}
