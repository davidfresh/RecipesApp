//
//  MealEntity.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation

struct MealsEntity: Codable {
    let meals: [MealEntity]
    
    func toDomain() throws -> Meals {
        return Meals(results: try meals.map{ try $0.toDomain() })
    }
}

struct MealEntity: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
    
    private enum CodingKeys: String, CodingKey {
        case strMeal
        case strMealThumb
        case idMeal
    }
    
    func toDomain() throws -> Meal {
        return Meal(nameOfMeal: strMeal,
                    imageOfMeal: getImageURL(),
                    IDMeal: idMeal)
    }
}

private extension MealEntity {
    func getImageURL() -> URL? {
        return URL(string: strMealThumb)
    }
}
