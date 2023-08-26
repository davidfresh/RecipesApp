//
//  MealDetailsProviderContract.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation
public enum MealDetailsProviderContractError: Error {
    case generic(error: String)
    
    public var errorDescription: String? {
        switch self {
        case .generic(let error):
            return error
        }
    }
}

public protocol MealDetailsProviderContract {
    func getMealDetails(IDMeal: String,
                      completion: @escaping (Result<MealsDetail, Error>) -> Void)
}
