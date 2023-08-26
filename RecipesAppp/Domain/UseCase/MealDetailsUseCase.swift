//
//  MealDetailsUseCase.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation
public protocol MealDetailsUseCaseContract {
    func getMealDetails(IDMeal: String,
                        completion: @escaping (Result<MealsDetail, Error>) -> Void)
}

public enum MealDetailsUseCaseError: Error {
    case generic(error: String)
    
    public var errorDescription: String? {
        switch self {
        case .generic(let error):
            return error
        }
    }
}

public final class MealDetailsUseCase {
    let provider: MealDetailsProviderContract
    
    public init(provider: MealDetailsProviderContract) {
        self.provider = provider
    }
}

extension MealDetailsUseCase: MealDetailsUseCaseContract {
    public func getMealDetails(IDMeal: String,
                               completion: @escaping (Result<MealsDetail, Error>) -> Void) {
        return provider.getMealDetails(IDMeal: IDMeal) { result in
            switch result {
            case .success(let mealDetail):
                completion(.success(mealDetail))
            case .failure(let error):
                if let providerError = error as? MealDetailsProviderContractError,
                   let message = providerError.errorDescription {
                    completion(.failure(MealDetailsUseCaseError.generic(error: message)))
                }
            }
        }
    }
    
}

