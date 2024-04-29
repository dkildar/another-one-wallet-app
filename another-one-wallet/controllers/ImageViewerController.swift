//
//  ImageViewerController.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 29.04.2024.
//

import Foundation
import SwiftUI

class ImageViewerController : ObservableObject {
    @Published var image: Image? = nil
    @Published var isViewerPresented = false
    
    func show(imageData: Data?) {
        if let image = imageData, let uiImage = UIImage(data: image) {
            self.image = Image(uiImage: uiImage)
            isViewerPresented.toggle()
        }
    }
}
