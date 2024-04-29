//
//  CardView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 24.04.2024.
//

import SwiftUI

struct ListCardView<Content: View, Action: View>: View {
    @Binding var title: String
    @Binding var systemIconName: String
    @Binding var accentColor: Color
    
    @ViewBuilder let content: Content
    @ViewBuilder let action: Action
    
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Image(systemName: systemIconName)
                        .foregroundStyle(accentColor)
                    Text(title)
                        .foregroundStyle(accentColor)
                        .fontWeight(.semibold)
                        .font(.system(size: 14))
                    Spacer()
                    action
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 4)
                
                content
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
