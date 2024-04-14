//
//  CoinGeckoClient.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.04.2024.
//

import Foundation
import Combine

actor CoinGeckoClient {
    static var shared = CoinGeckoClient()
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
    
    func fetchPrice(currency: String, opposite: String) -> AnyPublisher<CoinGeckoPriceResponse, Error> {
        guard var urlComponents = URLComponents(url: URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=USD")!, resolvingAgainstBaseURL: false) else {
            fatalError("No URL for CGClient")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "ids", value: currency),
            URLQueryItem(name: "vs_currencies", value: opposite)
        ]
        
        guard let url = urlComponents.url else {
            fatalError("No computed URL for CGClient")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        debugPrint(request)
        
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
            .decode(type: CoinGeckoPriceResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}
