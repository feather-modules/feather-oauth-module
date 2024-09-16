//
//  File.swift
//
//  Created by gerp83 on 25/08/2024
//

import FeatherModuleKit
import UserModule
import UserModuleKit
import XCTest

final class OauthClientTests: TestCase {

    func testCreate() async throws {
        let roleDetail = try await module.oauthRole.create(
            .mock()
        )
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: [roleDetail.key]
        )
        let detail = try await module.oauthClient.create(input)
        XCTAssertEqual(detail.name, input.name)
        XCTAssertEqual(detail.type, input.type)
        XCTAssertEqual(detail.redirectUri, input.redirectUri)
        XCTAssertEqual(detail.loginRedirectUri, input.loginRedirectUri)
        XCTAssertEqual(detail.issuer, input.issuer)
        XCTAssertEqual(detail.audience, input.audience)
        XCTAssertEqual(detail.roles?.count, input.roleKeys?.count)
    }

    func testDetail() async throws {
        let roleDetail = try await module.oauthRole.create(
            .mock()
        )
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: [roleDetail.key]
        )
        let detail = try await module.oauthClient.create(input)
        let savedDetail = try await module.oauthClient.require(detail.id)
        XCTAssertEqual(detail.name, savedDetail.name)
        XCTAssertEqual(detail.type, savedDetail.type)
        XCTAssertEqual(detail.redirectUri, savedDetail.redirectUri)
        XCTAssertEqual(detail.loginRedirectUri, input.loginRedirectUri)
        XCTAssertEqual(detail.issuer, savedDetail.issuer)
        XCTAssertEqual(detail.audience, savedDetail.audience)
        XCTAssertEqual(detail.roles?.count, savedDetail.roles?.count)
    }

    func testList() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: nil
        )

        let input2 = User.OauthClient.Create(
            name: "name2",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: nil
        )

        let _ = try await module.oauthClient.create(input)
        let _ = try await module.oauthClient.create(input2)
        let list = try await module.oauthClient.list(
            User.OauthClient.List.Query(
                search: nil,
                sort: .init(by: .name, order: .asc),
                page: .init()
            )
        )
        XCTAssertTrue(list.count == 2)
    }

    func testPatch() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: nil
        )
        let detail = try await module.oauthClient.create(input)

        let patchedDetail = try await module.oauthClient.patch(
            detail.id,
            .init(name: "newName")
        )
        XCTAssertEqual(patchedDetail.name, "newName")
    }

    func testUpdate() async throws {
        let input = User.OauthClient.Create(
            name: "name",
            type: .app,
            redirectUri: "redirectUri",
            loginRedirectUri: "loginRedirectUri",
            issuer: "issuer",
            audience: "audience",
            roleKeys: nil
        )
        let detail = try await module.oauthClient.create(input)

        let updateDetail = try await module.oauthClient.update(
            detail.id,
            .init(
                name: "newName",
                type: .app,
                redirectUri: "newRedirectUri",
                loginRedirectUri: "newLoginRedirectUri",
                issuer: "newIssuer",
                audience: "newAudience",
                roleKeys: nil
            )
        )
        XCTAssertEqual(updateDetail.name, "newName")
        XCTAssertEqual(updateDetail.type, .app)
        XCTAssertEqual(updateDetail.redirectUri, "newRedirectUri")
        XCTAssertEqual(updateDetail.loginRedirectUri, "newLoginRedirectUri")
        XCTAssertEqual(updateDetail.issuer, "newIssuer")
        XCTAssertEqual(updateDetail.audience, "newAudience")
    }

}
