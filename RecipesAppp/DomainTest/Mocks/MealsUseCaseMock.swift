//
//  MealsUseCaseMock.swift
//  RecipesAppp
//
//  Created by David on 25/08/23.
//


enum MealsUseCaseMockError: Error {
    case generic
}

final class MealsUseCaseMock: MealsUseCaseContract {
  
    
    var meals: Meals?
    
    init(meals: Meals?) {
        self.meals = meals
    }
    func getListOfMeals(categoryName: String, completion: @escaping (Result<[Meal], Error>) -> Void) {
        if let meals = meals?.results {
            completion(.success(meals))
        } else {
            completion(.failure(MealsUseCaseMockError.generic))
        }
    }

}

extension MealsUseCaseMock {
    func orderMeals(_ meals: Meals) -> [Meal] {
        let sortedMeals = meals.results.sorted { $0 < $1 }
        return sortedMeals.compactMap { $0}
    }
}
