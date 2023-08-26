//
//  MealDetailsProvider.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation

public class MealDetailsProvider {
    private let apiClient: APIClient
    
    public init() {
        apiClient = APIClient()
    }
}

extension MealDetailsProvider: MealDetailsProviderContract {
    public func getMealDetails(IDMeal: String,
                               completion: @escaping (Result<MealsDetail, Error>) -> Void) {
        apiClient.execute(endpoint: .getlMealDetails(idMeal: IDMeal)) { (response: WebServiceResponse<MealsDetailEntity>) in
            guard case .success(modelData: let entity) = response,
                  let model = try? entity?.toDomain() else {
                      if case .failure(let error) = response,
                         let webError = error as? WebServiceProtocolError,
                         let message = webError.errorDescription {
                          completion(.failure(MealDetailsProviderContractError.generic(error: message)))
                      }
                      return
                  }
            completion(.success(model))
        }
    }
    
}
