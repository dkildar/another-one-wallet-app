//
//  CustomButtonView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ListIconView: View {
    
    let string: String
    
    init(string: String) {
        self.string = string
    }
    
    @State private var tapped: Bool = Bool()
    
    var body: some View {
        
        Image(systemName: string)
            .resizable()
            .scaledToFit()
            .frame(width: DeviceReader.shared.size - 5.0, height: DeviceReader.shared.size - 5.0)
            .foregroundColor(Color.white)
            .padding(8.0)
            .background(Color.blue)
            .cornerRadius(10.0)
        
    }
    
}



class DeviceReader: ObservableObject {
    
    let size: CGFloat
    
    init() {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: self.size = 24.0
        case .pad: self.size = 32.0
        case .mac: self.size = 48.0
        default: self.size = 24.0
        }
        
    }
    
    static let shared: DeviceReader = DeviceReader()
    
}
