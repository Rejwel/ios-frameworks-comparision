//
//  TextError.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 15/01/2024.
//

import SwiftUI

struct TextError: View {
    
    var errorMessage: String
    
    var body: some View {
        Text("\(errorMessage)")
            .foregroundStyle(.red)
            .padding(10)
            .overlay {
                Color.red
                    .opacity(0.3)
                    .clipShape(.buttonBorder)
            }
    }
}

#Preview {
    TextError(errorMessage: "You have to be minimum 18 years old")
}
