import FeatherModuleKit
import FeatherValidation
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

extension User.OauthRole.Create {

    static func mock(
        _ i: Int = 1,
        permissionKeys: [ID<System.Permission>] = []
    ) -> User.OauthRole.Create {
        .init(
            key: .init(rawValue: "key\(i)"),
            name: "name-\(i)",
            notes: "notes-\(i)",
            permissionKeys: permissionKeys
        )
    }
}

final class OauthRoleTests: TestCase {

    func testCreate() async throws {

        let detail = try await module.oauthRole.create(
            .mock()
        )

        XCTAssertEqual(detail.key.rawValue, "key1")
    }

    func testCreateInvalid() async throws {
        do {
            _ = try await module.oauthRole.create(
                .init(
                    key: .init(rawValue: "a"),
                    name: "",
                    notes: nil
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["key"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCreateInvalidUnique() async throws {
        _ = try await module.oauthRole.create(
            .mock()
        )

        do {
            _ = try await module.oauthRole.create(
                .init(
                    key: .init(rawValue: "key1"),
                    name: "",
                    notes: nil
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["key"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCreatePermissions() async throws {

        let p = try await module.system.permission.create(
            .init(
                key: .init(rawValue: "a.b.c"),
                name: "abc"
            )
        )
        let detail = try await module.oauthRole.create(
            .mock(permissionKeys: [p.key])
        )

        XCTAssertEqual(detail.permissions.count, 1)
        XCTAssertEqual(detail.permissions[0].key, p.key)
    }

    func testDetail() async throws {
        let detail = try await module.oauthRole.create(
            .mock()
        )

        let role = try await module.oauthRole.require(detail.key)
        XCTAssertEqual(role.key, detail.key)
    }

    func testUpdate() async throws {
        let detail = try await module.oauthRole.create(
            .mock()
        )

        let role = try await module.oauthRole.update(
            detail.key,
            .init(
                key: detail.key,
                name: "name-2",
                notes: "notes-2",
                permissionKeys: []
            )
        )
        XCTAssertEqual(role.key, detail.key)
        XCTAssertEqual(role.name, "name-2")
        XCTAssertEqual(role.notes, "notes-2")
    }

    func testUpdateInvalidUnique() async throws {
        let detail1 = try await module.oauthRole.create(
            .mock(1)
        )
        let detail2 = try await module.oauthRole.create(
            .mock(2)
        )

        do {
            _ = try await module.oauthRole.update(
                detail1.key,
                .init(
                    key: detail2.key,
                    name: "",
                    permissionKeys: []
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["key"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testPatch() async throws {
        let detail = try await module.oauthRole.create(
            .mock()
        )

        let role = try await module.oauthRole.patch(
            detail.key,
            .init(
                key: detail.key,
                name: "name-2",
                notes: "notes-2"
            )
        )
        XCTAssertEqual(role.key, detail.key)
        XCTAssertEqual(role.name, "name-2")
        XCTAssertEqual(role.notes, "notes-2")
    }

    func testPatchInvalidUnique() async throws {
        let detail1 = try await module.oauthRole.create(
            .mock(1)
        )
        let detail2 = try await module.oauthRole.create(
            .mock(2)
        )

        do {
            _ = try await module.oauthRole.patch(
                detail1.key,
                .init(
                    key: detail2.key
                )
            )
            XCTFail("Validation test should fail.")
        }
        catch let error as ValidatorError {
            XCTAssertEqual(error.failures.count, 1)
            let keys = error.failures.map(\.key).sorted()
            XCTAssertEqual(keys, ["key"])
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testDelete() async throws {
        let detail = try await module.oauthRole.create(
            .mock()
        )

        try await module.oauthRole.bulkDelete(
            ids: [detail.key]
        )

        let roles = try await module.oauthRole.reference(
            ids: [
                detail.key
            ]
        )
        XCTAssertTrue(roles.isEmpty)
    }
}
