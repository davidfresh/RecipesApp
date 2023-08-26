//
//  Meal.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation

public struct Meals: Equatable {
    public let results: [Meal]
    
    public init(results: [Meal]) {
        self.results = results
    }
}

public struct Meal: Equatable, Comparable {
    public static func < (lhs: Meal, rhs: Meal) -> Bool {
        return lhs.nameOfMeal < rhs.nameOfMeal
    }
    
    public let nameOfMeal: String
    public let imageOfMeal: URL?
    public let IDMeal: String
    
    public init(nameOfMeal: String,
                imageOfMeal: URL?,
                IDMeal: String) {
        self.nameOfMeal = nameOfMeal
        self.imageOfMeal = imageOfMeal
        self.IDMeal = IDMeal
    }
}
