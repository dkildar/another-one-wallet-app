//
//  SecureAddressView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 16.05.2024.
//

import SwiftUI
import UniformTypeIdentifiers
import CoreImage.CIFilterBuiltins

struct SecureAddressView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var account: BankAccount
    
    @State var isRevealed = false
    @State var isCopied = false
    @State var isQRCodePresented = false
    
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
                    Button {
                        isQRCodePresented.toggle()
                    } label: {
                        Image(systemName: "qrcode")
                    }
                }
                .padding(.top, 4)
            })
        .sheet(isPresented: $isQRCodePresented) {
            VStack(alignment: .center, spacing: 32) {
                Text(account.address ?? "")
                    .monospaced()
                
                Image(uiImage: generateQRCode(from: account.address ?? ""))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
                
                Image(systemName: "xmark")
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: 64, height: 64, alignment: .center)
                    .background(
                        Circle()
                            .fill(colorScheme == .dark ? .white : .black)
                    )
                    .onTapGesture {
                        isQRCodePresented = false
                    }
            }
            .padding()
        }
    }
    
    private func generateQRCode(from string: String) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        filter.message = Data(string.utf8)
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
