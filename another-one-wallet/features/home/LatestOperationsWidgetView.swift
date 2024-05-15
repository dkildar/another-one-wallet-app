//
//  LatestOperationsWidgetView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 15.05.2024.
//

import SwiftUI

struct LatestOperationsWidgetView: View {
    var body: some View {
        ListCardView(
            title: .constant("History"),
            systemIconName: .constant("clock"),
            accentColor: .constant(.cyan)) {
            } action: {
                
            }
    }
}

#Preview {
    LatestOperationsWidgetView()
}
