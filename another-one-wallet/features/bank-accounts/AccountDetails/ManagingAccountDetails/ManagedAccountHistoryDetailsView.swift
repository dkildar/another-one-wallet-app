//
//  ManagedAccountHistoryDetailsView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 29.04.2024.
//

import SwiftUI

struct ManagedAccountHistoryDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var persistenceController: PersistenceController
    @EnvironmentObject var imageViewerController: ImageViewerController
    
    @Binding var record: ManagedAccountRecord
    @State var isConfirmationPresented = false
    @State var isEditPresented = false
    
    var body: some View {
        List {
            VStack(alignment: .center) {
                Image(systemName: record.account?.icon ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.blue)
                    .padding()
                    .background(
                        Circle().fill(Color.white)
                    )
                Text((record.type == "incoming" ? "+" : "-") + String(format: "%.2f", record.amount) + (record.account?.getCurrencySymbol() ?? "$"))
                    .foregroundStyle(record.type == "incoming" ? .green : .red)
                    .font(.largeTitle)
                
                Text(String(record.created?.formatted(.dateTime.hour().minute().day().month().year()) ?? ""))
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            if let text = record.text {
                if !text.isEmpty {
                    ListCardView(
                        title: .constant("Note"),
                        systemIconName: .constant("note.text"),
                        accentColor: .constant(.gray),
                        content: {
                            Text(text)
                                .frame(maxWidth: .infinity, alignment: .topLeading)
                        }, action: {
                            
                        })
                }
            }
            
            if let image = record.image, let uiImage = UIImage(data: image) {
                ListCardView(
                    title: .constant("Image"),
                    systemIconName: .constant("photo"),
                    accentColor: .constant(.blue),
                    content: {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .clipShape(.rect(cornerRadius: 8))
                            .onTapGesture {
                                imageViewerController.show(imageData: image)
                            }
                    }, action: {
                        
                    })
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        isEditPresented.toggle()
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    
                    Button {
                        isConfirmationPresented.toggle()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .foregroundStyle(.red)
                } label: {
                    Image(systemName: "gear.circle")
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            if let account = record.account {
                ManagedAccountRecordFormView(presetAccount: .constant(account), presetRecord: .constant(record))
            }
        }
        .confirmationDialog("Are you sure?", isPresented: $isConfirmationPresented) {
            Button("Yes, delete", role: .destructive) {
                persistenceController.delete(item: record)
                dismiss()
            }
        }
    }
}
