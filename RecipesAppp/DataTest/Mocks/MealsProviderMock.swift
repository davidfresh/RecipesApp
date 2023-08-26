//
//  MealsProviderMock.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import Foundation

enum MealsProviderMockProviderContractError: Error {
    case generic
}

class MealsProviderMock {
    private let apiClientMock: APIClientMock
    
    init(result: Result<Data, Error>) {
        apiClientMock = APIClientMock(result: result)
    }
    
    func getListMeals(categoryName: String, completion: @escaping (Result<Meals, Error>) -> Void) {
        apiClientMock.execute(endpoint: .getListDessert(categoryName: categoryName)) { (response: WebServiceResponse<MealsEntity>) in
            guard case .success(modelData: let entity) = response,
                  let model = try? entity?.toDomain() else {
                      completion(.failure(MealsProviderMockProviderContractError.generic))
                      return
                  }
            completion(.success(model))
        }
    }
}
