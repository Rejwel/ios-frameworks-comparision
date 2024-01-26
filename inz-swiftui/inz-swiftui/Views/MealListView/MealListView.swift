//
//  ContentView.swift
//  inz-swiftui
//
//  Created by Paweł Dera on 06/11/2023.
//

import SwiftUI

struct Meal: Identifiable {
    let id: UUID = UUID()
    let image: Image
    let name: Text
    let cookingTime: Int
}

let Meals = [
    Meal(image: Image(.foodCake), name: Text("Cake"), cookingTime: 45),
    Meal(image: Image(.foodBurger), name: Text("Burger"), cookingTime: 60),
    Meal(image: Image(.foodPasta), name: Text("Pasta"), cookingTime: 75),
    Meal(image: Image(.foodSalad), name: Text("Salad"), cookingTime: 30),
    Meal(image: Image(.foodFishSoup), name: Text("Fish Soup"), cookingTime: 45),
    Meal(image: Image(.foodIceCream), name: Text("Ice Cream"), cookingTime: 60),
    Meal(image: Image(.foodPumpkinSoup), name: Text("Pumpkin Soup"), cookingTime: 120),
    Meal(image: Image(.foodChickenWings), name: Text("Chicken Wings"), cookingTime: 75)
]

struct MealListView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List(Meals) { meal in
                    NavigationLink(destination: MealDetailsView(meal: meal)) {
                        MealCell(mealImage: meal.image,
                                 mealName: meal.name,
                                 mealCookingTime: meal.cookingTime)
                    }
                }
            }
            .navigationTitle("Pick your food")
        }
    }
}

struct MealCell: View {
    
    let mealImage: Image
    let mealName: Text
    let mealCookingTime: Int
    
    var body: some View {
        HStack {
            mealImage
                .resizable()
                .frame(width: 64, height: 64)
                .clipShape(.circle)
                .scaledToFit()
            VStack(alignment: .leading) {
                mealName
                    .bold()
                Text("\(mealCookingTime) min cooking time")
                    .foregroundStyle(.gray)
            }
            .padding(.leading, 16)
        }
    }
}

#Preview {
    MealListView()
}
