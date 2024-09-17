import FeatherModuleKit

public protocol AuthorizationCodeInterface: Sendable {

    func create(
        _ input: Oauth.AuthorizationCode.Create
    ) async throws -> Oauth.AuthorizationCode.Detail

    func require(
        _ id: ID<Oauth.AuthorizationCode>
    ) async throws -> Oauth.AuthorizationCode.Detail
    
    func getByCode(
        _ code: String
    ) async throws -> Oauth.AuthorizationCode.Detail

}
