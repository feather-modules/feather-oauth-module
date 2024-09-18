//
//  File.swift
//
//
//  Created by Tibor Bodecs on 30/01/2024.
//

import DatabaseMigrationKit
import FeatherComponent
import FeatherRelationalDatabase
import FeatherRelationalDatabaseDriverSQLite
import Logging
import MigrationKit
import NIO
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var migrator: Migrator!

    override func setUp() async throws {
        self.components = ComponentRegistry()
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let threadPool = NIOThreadPool(numberOfThreads: 1)
        threadPool.start()

        try await components.addRelationalDatabase(
            SQLiteRelationalDatabaseComponentContext(
                eventLoopGroup: eventLoopGroup,
                connectionSource: .init(
                    configuration: .init(
                        storage: .memory,
                        enableForeignKeys: true
                    ),
                    threadPool: threadPool
                )
            )
        )

        try await components.run()

        self.migrator = Migrator(
            components: components,
            storage: MigrationEntryStorageEphemeral()
        )
    }

    override func tearDown() async throws {
        try await components.shutdown()
        try await eventLoopGroup.shutdownGracefully()
    }
}
