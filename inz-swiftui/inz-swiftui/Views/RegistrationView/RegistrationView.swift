//
//  RegistrationView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 15/01/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @Binding var user: User
    
    var body: some View {
        NavigationStack {
            BirthDateView(user: $user)
        }
    }
}

#Preview {
    RegistrationView(user: .constant(.init(birthDate: Date(), phoneNumber: "", email: "", firstName: "", lastName: "", password: "")))
}
