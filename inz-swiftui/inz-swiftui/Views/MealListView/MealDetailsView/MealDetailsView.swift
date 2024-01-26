//
//  MealDetailsView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 08/11/2023.
//

import SwiftUI

struct MealDetailsView: View {
    
    let meal: Meal
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                meal.image
                    .resizable()
                    .frame(width: 320, height: 320)
                    .clipShape(.buttonBorder)
                    .navigationTitle(meal.name)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: isAnimating)
                    
                meal.name
                    .bold()
                
                Text("\(meal.cookingTime) min cooking time")
                    .foregroundStyle(.gray)
               
                Button {
                    isAnimating.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isAnimating.toggle()
                    }
                } label: {
                    Text("Add to favorites")
                    Image(systemName: "heart.fill")
                }
                .tint(.pink)
                .buttonStyle(.bordered)
                .controlSize(.large)
                .accessibilityIdentifier("add-to-favorites-button")
            }
            .padding(.top, 16)
            Spacer()
        }
    }
}

#Preview {
    MealDetailsView(meal: Meal(image: Image(.foodCake), name: Text("Cake"), cookingTime: 45))
}
