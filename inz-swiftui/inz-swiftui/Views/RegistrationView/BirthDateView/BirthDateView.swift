//
//  BirthDateView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 15/01/2024.
//

import SwiftUI

struct BirthDateView: View {
    
    @Binding var user: User
    @State var showError: Bool = false
    
    var isOver18YearsOld: Bool {
        return Calendar.current.date(byAdding: .year, value: -18, to: Date())! > user.birthDate
        ? true
        : false
    }
    
    private let ERROR_MESSAGE: String = "You have to be minimum 18 years old!"
    
    var body: some View {
        VStack {
            
            Spacer()
            
            if isOver18YearsOld {
                Text("🎁 \(user.birthDate.formatted(date: .long, time: .omitted)) 🎉")
                    .bold()
            }
            
            DatePicker("Select your birthdate", selection: $user.birthDate, in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
                .onChange(of: user.birthDate) {
                    showError = !isOver18YearsOld
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
            
            NavigationLink(destination: PhoneNuberView(user: $user)) {
                Text("Continue")
                Image(systemName: "arrowshape.right.fill")
            }
            .padding(.bottom, 32)
            .tint(.accentColor)
            .buttonStyle(.bordered)
            .controlSize(.large)
            .accessibilityIdentifier("add-to-favorites-button")
            .disabled(!isOver18YearsOld)
   
        }
        .navigationTitle("Your Birthdate")
    }
}

#Preview {
    BirthDateView(user: .constant(.init(birthDate: Date(), phoneNumber: "", email: "", firstName: "", lastName: "", password: "")))
}
