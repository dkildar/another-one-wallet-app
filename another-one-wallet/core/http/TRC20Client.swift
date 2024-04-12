//
//  HttpManager.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import Foundation
import Combine

actor TRC20Client {
    static var shared = TRC20Client()
    private var configuration = URLSessionConfiguration.default
    private var session: URLSession
    
    init() {
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        session = URLSession(configuration: configuration)
    }
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()
    
    func fetchTokens(address: String) -> AnyPublisher<TRC20TokensResponse, Error> {
        return runSecured(urlString: "https://apilist.tronscanapi.com/api/account/tokens", method: "GET", queryParams: ["address": address], responseEntity: TRC20TokensResponse.self)
    }
    
    private func runSecured<T : Codable>(urlString: String, method: String, queryParams: [String:String], responseEntity: T.Type) -> AnyPublisher<T, Error> {
        guard var urlComponents = URLComponents(url: URL(string: urlString)!, resolvingAgainstBaseURL: false) else {
            fatalError("No URL for TRC20")
        }
        
        urlComponents.queryItems = queryParams.map({ (key: String, value: String) in
            URLQueryItem(name: key, value: value)
        })
        
        guard let url = urlComponents.url else {
            fatalError("No computed URL for TRC20")
        }
        
        var request = buildRequest(url: url)
        request.httpMethod = method
        debugPrint(request)
        
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
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(ProcessInfo.processInfo.environment["TRONSCAN_API_KEY"] ?? "", forHTTPHeaderField: "TRON-PRO-API-KEY")
        return request
    }
}
