import FeatherModuleKit

public protocol OauthFlowInterface: Sendable {

    func check(
        _ grantType: Oauth.Flow.FlowType?,
        _ clientId: String,
        _ clientSecret: String?,
        _ redirectUri: String?,
        _ scope: String?
    ) async throws -> String?

    func getCode(_ request: Oauth.Flow.AuthorizationPostRequest) async throws
        -> String

    func getJWT(
        _ request: Oauth.Flow.JwtRequest,
        userData: Oauth.Flow.UserData?
    ) async throws
        -> Oauth.Flow.JwtResponse

}
