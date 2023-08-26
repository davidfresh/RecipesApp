//
//  MealsProvider.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
public class MealsProvider {
    private let apiClient: APIClient
    
    public init() {
        apiClient = APIClient()
    }
}

extension MealsProvider: MealsProviderContract {
    public func getListMeals(categoryName: String,
                             completion: @escaping (Result<Meals, Error>) -> Void) {
        apiClient.execute(endpoint: .getListDessert(categoryName: categoryName)) { (response: WebServiceResponse<MealsEntity>) in
            guard case .success(modelData: let entity) = response,
                  let model = try? entity?.toDomain() else {
                      if case .failure(let error) = response,
                         let webError = error as? WebServiceProtocolError,
                         let message = webError.errorDescription {
                          completion(.failure(MealsProviderContractError.generic(error: message)))
                      }
                      return
                  }
            completion(.success(model))
        }

    }
}
