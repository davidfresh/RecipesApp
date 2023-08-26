//
//  MealsUseCase.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

public protocol MealsUseCaseContract {
    func getListOfMeals(categoryName:String,
                        completion: @escaping (Result<[Meal], Error>) -> Void)
}

public enum MealsUseCaseError: Error {
    case generic(error: String)
    
    public var errorDescription: String? {
        switch self {
        case .generic(let error):
            return error
        }
    }
}

public final class MealsUseCase {
    let provider: MealsProviderContract
    
    public init(provider: MealsProviderContract) {
        self.provider = provider
    }
}

extension MealsUseCase: MealsUseCaseContract {
    public func getListOfMeals(categoryName: String,
                               completion: @escaping (Result<[Meal], Error>) -> Void) {
        return provider.getListMeals(categoryName: categoryName) { result in
            switch result {
            case .success(let meals):
                let sortedMeals = self.orderMeals(meals)
                completion(.success(sortedMeals))
            case .failure(let error):
                if let providerError = error as? MealsProviderContractError,
                   let message = providerError.errorDescription {
                    completion(.failure(MealsUseCaseError.generic(error: message)))
                }
            }
        }
    }
    
}

private extension MealsUseCase {
    func orderMeals(_ meals: Meals) -> [Meal] {
        let sortedMeals = meals.results.sorted { $0 < $1 }
        return sortedMeals.compactMap { $0}
    }
}
