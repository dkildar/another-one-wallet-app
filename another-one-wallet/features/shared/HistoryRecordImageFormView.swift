//
//  HistoryRecordImageFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 29.04.2024.
//

import SwiftUI
import PhotosUI

private struct PickButton: View {
    @Binding var icon: String
    @Binding var text: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct HistoryRecordImageFormView: View {
    @Binding var selectedImageData: Data?
    var onSelect: (_ data: Data?) -> Void
    
    @State var selectedImage: PhotosPickerItem? = nil
    @State var cameraImage: UIImage? = nil
    @State var isCameraPresented = false
    
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
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    } else {
                        HStack {
                            Spacer()
                            
                            PickButton(icon: .constant("camera.fill"), text: .constant("Camera"))
                            .onTapGesture {
                                isCameraPresented.toggle()
                            }
                            .fullScreenCover(isPresented: $isCameraPresented) {
                                CameraAccessView(selectedImage: $cameraImage)
                                    .ignoresSafeArea()
                            }
                            
                            Spacer()
                            Divider()
                            Spacer()
                            
                            PhotosPicker(
                                selection: $selectedImage,
                                matching: .images,
                                photoLibrary: .shared()
                            ) {
                                PickButton(icon: .constant("photo.on.rectangle.angled"), text: .constant("Gallery"))
                            }
                            Spacer()
                        }
                        .padding(.bottom, 8)
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
        .onChange(of: cameraImage) { newValue in
            onSelect(newValue?.heicData())
        }
    }
}
