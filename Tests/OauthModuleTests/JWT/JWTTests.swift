import Crypto
import Foundation
import JWTKit
import UserModuleKit
import XCTest

final class JWTTests: XCTestCase {

    private func createKeyPair() -> (String, String) {
        let privateKeyData = Curve25519.Signing.PrivateKey()
        let publicKeyData = privateKeyData.publicKey
        let eddsaPrivateKeyBase64 = privateKeyData.rawRepresentation
            .base64EncodedString()
        let eddsaPublicKeyBase64 = publicKeyData.rawRepresentation
            .base64EncodedString()
        return (eddsaPublicKeyBase64, eddsaPrivateKeyBase64)
    }

    func testKeyPairCreation() async throws {
        let keyPair = createKeyPair()
        XCTAssertTrue(keyPair.0.count > 0)
        XCTAssertTrue(keyPair.1.count > 0)
    }

    func testSign() async throws {
        let keyPair = createKeyPair()
        let privateKey = try EdDSA.PrivateKey(
            d: keyPair.1,
            curve: .ed25519
        )
        let kid = JWKIdentifier(string: "kid")
        let keyCollection = await JWTKeyCollection()
            .add(
                eddsa: privateKey,
                kid: kid
            )
        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "issuer"),
            aud: AudienceClaim(value: ["audience"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(60))
        )
        let jwt = try await keyCollection.sign(payload, kid: kid)

        XCTAssertTrue(jwt.count > 0)
    }

    func testSignAndVerifyWithPublicKey() async throws {
        let keyPair = createKeyPair()
        let publicKey = try EdDSA.PublicKey(
            x: keyPair.0,
            curve: .ed25519
        )
        let privateKey = try EdDSA.PrivateKey(
            d: keyPair.1,
            curve: .ed25519
        )

        let kid = JWKIdentifier(string: "kid")
        let keyCollection = await JWTKeyCollection()
            .add(
                eddsa: privateKey,
                kid: kid
            )

        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "issuer"),
            aud: AudienceClaim(value: ["audience"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(60))
        )
        let jwt = try await keyCollection.sign(payload, kid: kid)

        let verifier = await JWTKeyCollection()
            .add(eddsa: publicKey)
        _ = try await verifier.verify(jwt, as: User.Oauth.Payload.self)
    }

    func testSignAndVerifyWithPrivateKey() async throws {
        let keyPair = createKeyPair()
        let privateKey = try EdDSA.PrivateKey(
            d: keyPair.1,
            curve: .ed25519
        )

        let kid = JWKIdentifier(string: "kid")
        let keyCollection = await JWTKeyCollection()
            .add(
                eddsa: privateKey,
                kid: kid
            )

        let payload = User.Oauth.Payload(
            iss: IssuerClaim(value: "issuer"),
            aud: AudienceClaim(value: ["audience"]),
            exp: ExpirationClaim(value: Date().addingTimeInterval(60))
        )
        let jwt = try await keyCollection.sign(payload, kid: kid)

        let verifier = await JWTKeyCollection()
            .add(eddsa: privateKey)
        _ = try await verifier.verify(jwt, as: User.Oauth.Payload.self)
    }

}
