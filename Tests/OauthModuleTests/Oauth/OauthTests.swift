import FeatherModuleKit
import SystemModule
import SystemModuleKit
import UserModule
import UserModuleKit
import XCTest

final class OauthTests: TestCase {

    func testCheckBadClient() async throws {
        let client = try await addTestClient(.app)
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: "client",
            redirectUri: client.redirectUri!,
            scope: "profile"
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCheckBadRedirectUri() async throws {
        let client = try await addTestClient(.app)
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: client.id.rawValue,
            redirectUri: "localhost",
            scope: "profile"
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCheckBadScope() async throws {
        let client = try await addTestClient(.app)
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri!,
            scope: "badScope"
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 3"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testCheck() async throws {
        let client = try await addTestClient(.app)
        let request = User.Oauth.AuthorizationGetRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri!,
            scope: "profile"
        )

        _ = try await module.oauth.check(
            nil,
            request.clientId,
            nil,
            request.redirectUri,
            request.scope
        )
    }

    // MARK: test getCode

    func testGetCodeBadClient() async throws {
        let client = try await addTestClient(.app)
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: "client",
            redirectUri: client.redirectUri!,
            scope: "profile",
            state: "state",
            accountId: user.id
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testGetCodeBadRedirectUri() async throws {
        let client = try await addTestClient(.app)
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: "localhost",
            scope: "profile",
            state: "state",
            accountId: user.id
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testGetCodeBadAccount() async throws {
        let client = try await addTestClient(.app)

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri!,
            scope: "profile",
            state: "state",
            accountId: .init(rawValue: "badId")
        )

        do {
            _ = try await module.oauth.check(
                nil,
                request.clientId,
                nil,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getCode(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 6"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testGetCode() async throws {
        let client = try await addTestClient(.app)
        let user = try await createUser()

        let request = User.Oauth.AuthorizationPostRequest(
            clientId: client.id.rawValue,
            redirectUri: client.redirectUri!,
            scope: "profile",
            state: "state",
            accountId: user.id
        )

        _ = try await module.oauth.check(
            nil,
            request.clientId,
            nil,
            request.redirectUri,
            request.scope
        )
        let newCode = try await module.oauth.getCode(request)
        XCTAssertEqual(true, newCode.count > 0)
    }

    // MARK: test exchange

    func testExchangeBadClient() async throws {
        let client = try await addTestClient(.app)
        let testData = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri!
        )

        let request = User.Oauth.JwtRequest(
            grantType: .authorization,
            clientId: "client",
            clientSecret: nil,
            code: testData,
            redirectUri: client.redirectUri,
            scope: nil
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testExchangeBadRedirectUri() async throws {
        let client = try await addTestClient(.app)
        let testData = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri!
        )

        let request = User.Oauth.JwtRequest(
            grantType: .authorization,
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: testData,
            redirectUri: "badRedirectUri",
            scope: nil
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 1"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testExchangeBadcode() async throws {
        let client = try await addTestClient(.app)
        _ = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri!
        )

        let request = User.Oauth.JwtRequest(
            grantType: .authorization,
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: "badCode",
            redirectUri: client.redirectUri,
            scope: nil
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                nil,
                request.redirectUri,
                nil
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 4"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testExchange() async throws {
        let client = try await addTestClient(.app)
        let testCode = try await createAuthorizationCode(
            client.id.rawValue,
            client.redirectUri!
        )

        let request = User.Oauth.JwtRequest(
            grantType: .authorization,
            clientId: client.id.rawValue,
            clientSecret: nil,
            code: testCode,
            redirectUri: client.redirectUri,
            scope: nil
        )
        _ = try await module.oauth.check(
            request.grantType,
            request.clientId,
            nil,
            request.redirectUri,
            nil
        )
        _ = try await module.oauth.getJWT(request)
    }

    // MARK: test server credentials

    func testServerCredentialsBadClient() async throws {
        let client = try await addTestClient(.server)

        let request = User.Oauth.JwtRequest(
            grantType: .clientCredentials,
            clientId: "badClient",
            clientSecret: client.clientSecret,
            code: nil,
            redirectUri: nil,
            scope: "server"
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                request.clientSecret,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testServerCredentialsBadSecret() async throws {
        let client = try await addTestClient(.server)

        let request = User.Oauth.JwtRequest(
            grantType: .clientCredentials,
            clientId: client.id.rawValue,
            clientSecret: "badSecret",
            code: nil,
            redirectUri: nil,
            scope: "server"
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                request.clientSecret,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 0"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testServerCredentialsBadScope() async throws {
        let client = try await addTestClient(.server)

        let request = User.Oauth.JwtRequest(
            grantType: .clientCredentials,
            clientId: client.id.rawValue,
            clientSecret: client.clientSecret,
            code: nil,
            redirectUri: nil,
            scope: "badScope"
        )

        do {
            _ = try await module.oauth.check(
                request.grantType,
                request.clientId,
                request.clientSecret,
                request.redirectUri,
                request.scope
            )
            _ = try await module.oauth.getJWT(request)
            XCTFail("Test should fail with User.OauthError")
        }
        catch let error as User.OauthError {
            XCTAssertEqual(true, error.localizedDescription.contains("error 3"))
        }
        catch {
            XCTFail("\(error)")
        }
    }

    func testServerCredentials() async throws {
        let client = try await addTestClient(.server)

        let request = User.Oauth.JwtRequest(
            grantType: .clientCredentials,
            clientId: client.id.rawValue,
            clientSecret: client.clientSecret,
            code: nil,
            redirectUri: nil,
            scope: "server"
        )

        _ = try await module.oauth.check(
            request.grantType,
            request.clientId,
            request.clientSecret,
            request.redirectUri,
            request.scope
        )
        _ = try await module.oauth.getJWT(request)
    }

    // MARK: private

    private func createAuthorizationCode(
        _ clientId: String,
        _ redirectUri: String
    ) async throws -> String {
        let user = try await createUser()
        let request = User.Oauth.AuthorizationPostRequest(
            clientId: clientId,
            redirectUri: redirectUri,
            scope: "profile",
            state: "state",
            accountId: user.id
        )
        return try await module.oauth.getCode(request)
    }

    private func createUser() async throws -> User.Account.Detail {
        let email = "test@user.com"
        let password = "ChangeMe1"

        return try await module.account.create(
            User.Account.Create(
                email: email,
                password: password,
                firstName: "firstName",
                lastName: "lastName",
                imageKey: "imageKey"
            )
        )
    }

    private func addTestClient(_ clientType: User.OauthClient.ClientType)
        async throws -> User.OauthClient.Detail
    {
        var roleKeys: [ID<User.OauthRole>]? = nil
        if clientType == .server {
            let role = try await module.oauthRole.create(
                .init(
                    key: .init(rawValue: "testRole"),
                    name: "testRole"
                )
            )
            roleKeys = []
            roleKeys?.append(role.key)
        }
        return try await module.oauthClient.create(
            .init(
                name: "client1",
                type: clientType,
                redirectUri: "localhost1",
                loginRedirectUri: "loginRedirectUri1",
                issuer: "issuer",
                audience: "audience",
                roleKeys: roleKeys
            )
        )
    }

}
