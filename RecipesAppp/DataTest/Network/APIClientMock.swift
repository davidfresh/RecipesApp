//
//  APIClientMock.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import Foundation

final class APIClientMock: WebServiceProtocol {
    let result: Result<Data, Error>
    
    init(result: Result<Data, Error>) {
        self.result = result
    }
    
    func execute<Output>(endpoint: APIRouter, completion: @escaping WebServiceHandler<Output>) where Output: Decodable {
        switch result {
        case .success(let data):
            do {
                let model = try JSONDecoder().decode(Output.self, from: data)
                completion(.success(modelData: model))
            } catch {
                completion(.failure(error: error))
            }
        case .failure(let error):
            completion(.failure(error: error))
        }
    }
}
