//
//  SecureAddressView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct SecureAddressView: View {
    @Binding var account: BankAccount
    
    @State var isRevealed = false
    @State var isCopied = false
    
    var text: String {
        get {
            let masked = Array(repeating: "*", count: account.address?.count ?? 0).joined()
            return isRevealed ? account.address ?? "" : masked
        }
    }
    
    var body: some View {
        GroupBox(
            label: Label(isCopied ? "Address copied!" : "Address", systemImage: "link")
                .font(.caption)
                .foregroundColor(isCopied ? .green : .blue),
            content: {
                HStack(alignment: .center) {
                    Text(text)
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .foregroundColor(isRevealed ? .blue : .gray)
                        .monospaced()
                        .onTapGesture {
                            UIPasteboard.general.setValue(
                                account.address ?? "",
                                forPasteboardType: UTType.plainText.identifier
                            )
                            withAnimation {
                                isCopied = true
                            }
                            Task {
                                try? await Task.sleep(nanoseconds: 5_000_000_000)
                                DispatchQueue.main.async {
                                    withAnimation {
                                        isCopied = false
                                    }
                                }
                            }
                        }
                    
                    Button {
                        withAnimation {
                            isRevealed.toggle()
                        }
                    } label: {
                        Image(systemName: isRevealed ? "eye.slash.fill" : "eye.fill")
                    }
                }
                .padding(.top, 4)
            })
    }
}
