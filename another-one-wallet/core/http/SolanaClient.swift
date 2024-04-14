//
//  SolanaClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
// 7tkTKTDaLS7Levk9wxA1qEe3HMxKMKCuB6mdKvzevm69

import Foundation
import Combine

actor SolanaClient {
    static var shared = SolanaClient()
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
    
    func fetchBalance(address: String) -> AnyPublisher<SolanaBalanceRPCResponse, Error> {
        guard let urlComponents = URLComponents(url: URL(string: "https://api.mainnet-beta.solana.com")!, resolvingAgainstBaseURL: false) else {
            fatalError("No URL for SOL")
        }
        
        guard let url = urlComponents.url else {
            fatalError("No computed URL for SOL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        debugPrint(request)
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "jsonrpc": "2.0",
            "id": 1,
            "method": "getBalance",
            "params": [address]
        ])
        
        return session
            .dataTaskPublisher(for: request)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    print((element.response as! HTTPURLResponse).statusCode)
                    throw URLError(.badServerResponse)
                }
                return element.data
            }
            .decode(type: SolanaBalanceRPCResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
