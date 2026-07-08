import Foundation

private struct LoginRequestBody: Encodable {
    let email: String
    let password: String
}

private struct LoginEndpoint: Endpoint {
    let email: String
    let password: String

    var url: URL { URL(string: "https://mock-api.iospocnews.local/v1/login")! }
    var method: String { "POST" }
    var body: Data? {
        try? JSONEncoder().encode(LoginRequestBody(email: email, password: password))
    }
}

final class AuthNetworkDataSource {
    private let networkService: NetworkService

    init() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockLoginURLProtocol.self]
        self.networkService = NetworkService(session: URLSession(configuration: configuration))
    }

    func login(email: String, password: String) async throws -> LoginResponseDTO {
        try await networkService.request(LoginEndpoint(email: email, password: password))
    }
}
