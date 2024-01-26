//
//  inz_swiftuiApp.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 06/11/2023.
//
import SwiftUI


struct User {
    var birthDate: Date
    var phoneNumber: String
    var email: String
    var firstName: String
    var lastName: String
    var password: String
}

@main
struct inz_swiftuiApp: App {
    
    @State var user = User(birthDate: Date(), phoneNumber: "", email: "", firstName: "", lastName: "", password: "")
    
    var body: some Scene {
        WindowGroup {
//            MealListView()
//            RegistrationView(user: $user)
            PhotosView()
        }
    }
}
