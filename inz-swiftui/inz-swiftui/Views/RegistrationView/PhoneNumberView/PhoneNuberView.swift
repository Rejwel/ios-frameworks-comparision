//
//  PhoneNuberView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 16/01/2024.
//

import SwiftUI

struct PhoneNuberView: View {
    
    @Binding var user: User
    @State var showError: Bool = false
    @FocusState var isInputActive: Bool
    
    var isCorrectPhoneNumber: Bool {
        let phoneRegex = #"(?<!\w)(\(?(\+|00)?48\)?)?[ -]?\d{3}[ -]?\d{3}[ -]?\d{3}(?!\w)"#
        let result = user.phoneNumber.range(
            of: phoneRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    private let ERROR_MESSAGE: String = "Your phone number is invalid!"
    
    var body: some View {
        VStack {
            
            Spacer()
            
            HStack {
                Spacer()
                CustomInput(text: "Type your phone number", identifier: "phone-number-input", field: $user.phoneNumber, isInputActive: _isInputActive)
                .onChange(of: user.phoneNumber) {
                    showError = !isCorrectPhoneNumber
                }
                Spacer()
            }
            
            if showError {
                HStack {
                    TextError(errorMessage: ERROR_MESSAGE)
                    Spacer()
                }
                .padding([.horizontal], 32)
                .padding(.top, 8)
            }
            
            Spacer()
            
            NavigationLink(destination: RegisterDetailsView(user: $user)) {
                Text("Continue")
                Image(systemName: "arrowshape.right.fill")
            }
            .padding(.bottom, 32)
            .tint(.accentColor)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .accessibilityIdentifier("continue-button")
            .disabled(!isCorrectPhoneNumber)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
        }
        .navigationTitle("Your Details")
    }
}

#Preview {
    PhoneNuberView(user: .constant(.init(birthDate: Date(), phoneNumber: "", email: "", firstName: "", lastName: "", password: "")))
}
