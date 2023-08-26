//
//  MealDetailsProviderMock.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import Foundation

enum MealDetailsProviderMockContractError: Error {
    case generic
}

class MealDetailsProviderMock {
    private let apiClientMock: APIClientMock
    
    init(result: Result<Data, Error>) {
        apiClientMock = APIClientMock(result: result)
    }
    
    func getMealDetails(IDMeal: String, completion: @escaping (Result<MealsDetail, Error>) -> Void) {
        apiClientMock.execute(endpoint: .getlMealDetails(idMeal: IDMeal)) { (response: WebServiceResponse<MealsDetailEntity>) in
            guard case .success(modelData: let entity) = response,
                  let model = try? entity?.toDomain() else {
                      completion(.failure(MealDetailsProviderMockContractError.generic))
                      return
                  }
            completion(.success(model))
        }
    }
}
