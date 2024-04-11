//
//  ManagedBankAccountFormView.swift
//  another-one-wallet
//
//  Created by Ildar Timerbaev on 11.04.2024.
//

import SwiftUI

struct ManagedBankAccountFormView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        BasicAccountCreateFormView(type: .Managing, submit: { account in
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
            }
            dismiss()
        }) {
            EmptyView()
        }
    }
}

#Preview {
    ManagedBankAccountFormView()
}
