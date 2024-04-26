//
//  HttpClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import Combine

class HttpClient {
    private var configuration = URLSessionConfiguration.default
    private var session: URLSession
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        session = URLSession(configuration: configuration)
    }
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()
    
    func request<T : Codable>(
        urlString: String,
        method: String,
        queryParams: [String:String],
        headers: [String: String],
        responseEntity: T.Type,
        body: Data? = nil
    ) -> AnyPublisher<T, Error> {
        guard var urlComponents = URLComponents(url: URL(string: urlString)!, resolvingAgainstBaseURL: false) else {
            fatalError("No URL for HTTPClient")
        }
        
        urlComponents.queryItems = queryParams.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = urlComponents.url else {
            fatalError("No computed URL for HTTPClient")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        debugPrint(request)
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        headers.forEach { name, value in
            request.setValue(value, forHTTPHeaderField: name)
        }
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: responseEntity.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func convertToAsync<T>(request: AnyPublisher<T, Error>) async throws -> T? {
        return try await withCheckedThrowingContinuation { continuation in
            Task {
                request
                    .sink(
                        receiveCompletion: { completion in
                            if case let .failure(error) = completion {
                                debugPrint("Account fetching failed with \(error)")
                                continuation.resume(throwing: error)
                            }
                        },
                        receiveValue: { response in
                            continuation.resume(returning: response)
                        }
                    )
                    .store(in: &cancellable)
            }
        }
    }
}
