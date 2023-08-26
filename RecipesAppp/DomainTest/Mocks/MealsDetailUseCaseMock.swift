//
//  MealsDetailUseCaseMock.swift
//  RecipesAppp
//
//  Created by David on 25/08/23.
//

import Foundation

enum MealsDetailUseCaseMockError: Error {
    case generic
}

final class MealsDetailUseCaseMock: MealDetailsUseCaseContract {
  
    var mealDetail: MealsDetail?
    
    init(mealDetail: MealsDetail?) {
        self.mealDetail = mealDetail
    }
    
    func getMealDetails(IDMeal: String, completion: @escaping (Result<MealsDetail, Error>) -> Void) {
        if let mealDetail = mealDetail {
            completion(.success(mealDetail))
        } else {
            completion(.failure(MealsDetailUseCaseMockError.generic))
        }
    }
}
