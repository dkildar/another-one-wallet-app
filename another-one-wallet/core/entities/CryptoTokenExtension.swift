//
//  CryptoTokenExtension.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 18.05.2024.
//

import Foundation

extension CryptoToken {
    func getUsdRate() -> Double {
        return (Double(usdBalance ?? "0.0") ?? 0.0) / (Double(balance ?? "0.0") ?? 0.0)
    }
}
