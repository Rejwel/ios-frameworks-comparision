//
//  RegisterDetailsView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 16/01/2024.
//

import SwiftUI

struct RegisterDetailsView: View {
    
    @Binding var user: User
    @State var showError: Bool = false
    @FocusState var isInputActive: Bool
    
    var isCorrectEmail: Bool {
        let emailRegex = #"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"#
        let result = user.email.range(
            of: emailRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    var isCorrectPassword: Bool {
        let passwordRegex = #"^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)(?=.*?[\W_]).{8,}$"#
        let result = user.password.range(
            of: passwordRegex,
            options: .regularExpression
        )
        return (result != nil)
    }
    
    private let ERROR_MESSAGE: String = "Your user details are invalid!"
    
    var body: some View {
        VStack {
            
            Spacer()
                    
            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    CustomInput(text: "Type your first name", identifier: "first-name-input", field: $user.firstName, isInputActive: _isInputActive)
                        .onChange(of: user.firstName) {
                            showError = !user.firstName.isEmpty
                        }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    CustomInput(text: "Type your last name", identifier: "last-name-input", field: $user.lastName, isInputActive: _isInputActive)
                        .onChange(of: user.lastName) {
                            showError = !user.lastName.isEmpty
                        }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    CustomInput(text: "Type your email", identifier: "email-input", field: $user.email, isInputActive: _isInputActive)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .onChange(of: user.email) {
                            showError = !isCorrectEmail
                        }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    SecureField("Type your password", text: $user.password)
                        .padding()
                        .background(.white)
                        .clipShape(.buttonBorder)
                        .shadow(radius: 6)
                        .padding(.horizontal, 24)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .accessibilityIdentifier("password-input")
                        .focused($isInputActive)
                        .onChange(of: user.password) {
                            showError = !isCorrectEmail
                        }
                    Spacer()
                }
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
            
            NavigationLink(destination: FinishedView()) {
                Text("Continue")
                Image(systemName: "arrowshape.right.fill")
            }
            .padding(.bottom, 32)
            .tint(.accentColor)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .accessibilityIdentifier("continue-button")
            .disabled(user.firstName.isEmpty || user.lastName.isEmpty || !isCorrectPassword || !isCorrectEmail)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
        }
        .navigationTitle("Your Phone Number")
    }
}

struct CustomInput: View {
    
    var text: String
    var identifier: String
    @Binding var field: String
    @FocusState var isInputActive: Bool
 
    var body: some View {
        TextField(text, text: $field)
            .padding()
            .background(.white)
            .clipShape(.buttonBorder)
            .shadow(radius: 6)
            .padding(.horizontal, 24)
            .textContentType(.familyName)
            .submitLabel(.done)
            .accessibilityIdentifier(identifier)
            .focused($isInputActive)
    }
}

#Preview {
    RegisterDetailsView(user: .constant(.init(birthDate: Date(), phoneNumber: "", email: "", firstName: "", lastName: "", password: "")))
}
