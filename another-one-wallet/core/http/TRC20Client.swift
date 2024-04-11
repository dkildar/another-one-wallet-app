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
    private var session = URLSession(configuration: .default)
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970
        return aDecoder
    }()
    
    func fetchAccount(address: String) -> AnyPublisher<TRC20AccountResponse, Error> {
        guard var urlComponents = URLComponents(url: URL(string: "https://apilist.tronscanapi.com/api/accountv2")!, resolvingAgainstBaseURL: false) else {
            fatalError("No URL for TRC20")
        }
        debugPrint("Fetching trc20 details for \(address)")
        
        urlComponents.queryItems = [URLQueryItem(name: "address", value: address)]
        
        guard let url = urlComponents.url else {
            fatalError("No computed URL for TRC20")
        }
        
        var request = buildRequest(url: url)
        request.httpMethod = "GET"
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                print(url)
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: TRC20AccountResponse.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func buildRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue(ProcessInfo.processInfo.environment["TRONSCAN_API_KEY"] ?? "", forHTTPHeaderField: "TRON-PRO-API-KEY")
        return request
    }
}
