import Foundation

final class MockLoginURLProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == "mock-api.iospocnews.local"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000)

            let email = requestBodyValue(forKey: "email") ?? ""
            let password = requestBodyValue(forKey: "password") ?? ""

            guard !email.isEmpty, password.count >= 6 else {
                let response = HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocolDidFinishLoading(self)
                return
            }

            let localPart = email.split(separator: "@").first.map(String.init) ?? "user"
            let displayName = localPart.replacingOccurrences(of: ".", with: " ").capitalized
            let json: [String: Any] = [
                "id": UUID().uuidString,
                "name": displayName,
                "email": email
            ]
            let data = try! JSONSerialization.data(withJSONObject: json)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}

    private func requestBodyValue(forKey key: String) -> String? {
        guard let body = readBody(),
              let json = try? JSONSerialization.jsonObject(with: body) as? [String: Any] else {
            return nil
        }
        return json[key] as? String
    }

    // URLSession moves POST bodies from httpBody to httpBodyStream before handing
    // the request to URLProtocol, so httpBody alone is unreliable here.
    private func readBody() -> Data? {
        if let body = request.httpBody {
            return body
        }
        guard let stream = request.httpBodyStream else { return nil }
        stream.open()
        defer { stream.close() }

        var data = Data()
        let bufferSize = 4096
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(&buffer, maxLength: bufferSize)
            if bytesRead <= 0 { break }
            data.append(buffer, count: bytesRead)
        }
        return data
    }
}
