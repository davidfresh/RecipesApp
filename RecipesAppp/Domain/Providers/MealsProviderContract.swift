//
//  MealsProviderContract.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
public enum MealsProviderContractError: Error {
    case generic(error: String)
    
    public var errorDescription: String? {
        switch self {
        case .generic(let error):
            return error
        }
    }
}

public protocol MealsProviderContract {
    func getListMeals(categoryName:String,
                      completion: @escaping (Result<Meals, Error>) -> Void)
}
