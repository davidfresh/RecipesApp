//
//  MealDetailsViewModel.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation

struct MealDetailsIngredientsAndMeasureViewModel: Equatable {
    var nameOfIngredient: String
    var measureOfIngredient: String
}

struct MealDetailsViewModel: Equatable {
     var nameOfMeal: String
     var instructions: String
     var ingredients: [MealDetailsIngredientsAndMeasureViewModel]
}
