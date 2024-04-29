//
//  HistoryRecordImageFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 29.04.2024.
//

import SwiftUI
import PhotosUI

struct HistoryRecordImageFormView: View {
    @Binding var selectedImageData: Data?
    var onSelect: (_ data: Data?) -> Void
    
    @State var selectedImage: PhotosPickerItem? = nil
    
    init(selectedImageData: Binding<Data?>, onSelect: @escaping (_: Data?) -> Void) {
        self._selectedImageData = selectedImageData
        self.onSelect = onSelect
    }
    
    var body: some View {
        ListCardView(
            title: .constant("Image"),
            systemIconName: .constant("photo.circle"),
            accentColor: .constant(.blue),
            content: {
                VStack {
                    if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                        VStack(spacing: 12) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(.rect(cornerRadius: 16))
                        }
                    } else {
                        PhotosPicker(
                            selection: $selectedImage,
                            matching: .images,
                            photoLibrary: .shared()
                        ) {
                            VStack(spacing: 4) {
                                Image(systemName: "photo.on.rectangle.angled")
                                    .foregroundColor(.gray)
                                Text("Gallery")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 8)
            },
            action: {
                if selectedImageData != nil {
                    Button {
                        onSelect(nil)
                        selectedImage = nil
                    } label: {
                        Text("Clear")
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            })
        .onChange(of: selectedImage) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self) {
                    onSelect(data)
                }
            }
        }
    }
}
