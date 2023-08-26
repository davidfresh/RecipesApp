//
//  ListMealsViewModel.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation


struct ListMealsViewModel: Equatable {
    var nameOfMeal: String
    var imageOfMeal: URL?
    var IDMeal: String
}

struct MealsViewModel: Equatable {
    var meals: [ListMealsViewModel]
}
