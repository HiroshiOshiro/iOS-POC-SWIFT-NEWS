import Foundation
import os

protocol Endpoint {
    var url: URL { get }
    var method: String { get }
    var body: Data? { get }
}

extension Endpoint {
    var method: String { "GET" }
    var body: Data? { nil }
}

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case httpStatus(Int)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "サーバーから不正なレスポンスを受信しました"
        case .httpStatus(let code):
            return "通信エラーが発生しました (status: \(code))"
        }
    }
}

final class NetworkService {
    private let session: URLSession
    private let logger = Logger(subsystem: "com.hiroshioshiro.iOSPOCSWIFTNEWS", category: "Network")

    init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(_ endpoint: Endpoint, decoder: JSONDecoder = NetworkService.defaultDecoder) async throws -> T {
        var urlRequest = URLRequest(url: endpoint.url)
        urlRequest.httpMethod = endpoint.method
        urlRequest.httpBody = endpoint.body
        if endpoint.body != nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        logRequest(urlRequest)

        do {
            let (data, response) = try await session.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            logResponse(urlRequest, httpResponse, data)

            guard let httpResponse else {
                throw NetworkError.invalidResponse
            }
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.httpStatus(httpResponse.statusCode)
            }

            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("⬅️ [Network] \(urlRequest.httpMethod ?? "GET") \(urlRequest.url?.absoluteString ?? "") failed: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }

    private func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? ""
        var message = "➡️ [Network] \(method) \(url)"
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            message += "\nBody: \(bodyString)"
        }
        logger.debug("\(message, privacy: .public)")
    }

    private func logResponse(_ request: URLRequest, _ response: HTTPURLResponse?, _ data: Data) {
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? ""
        let status = response.map { "\($0.statusCode)" } ?? "unknown"
        var message = "⬅️ [Network] \(method) \(url) -> \(status)"
        if let bodyString = String(data: data, encoding: .utf8) {
            message += "\nResponse: \(bodyString)"
        }
        logger.debug("\(message, privacy: .public)")
    }

    static let defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }()
}
