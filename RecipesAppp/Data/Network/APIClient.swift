//
//  APIClient.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
import Alamofire

final class APIClient: WebServiceProtocol {
    func execute<Output>(endpoint: APIRouter, completion: @escaping WebServiceHandler<Output>) where Output : Decodable {
        if !validateConnectInternet() {
            completion(.failure(error: WebServiceProtocolError.noConnection))
            return
        }
        let request = endpoint as URLRequestConvertible
        AF.request(request)
            .logRequest()
            .validate { (_, httpResponse, _) -> DataRequest.ValidationResult in
                if self.isOccuringAnError(response: httpResponse) {
                    return .failure(self.getError(response: httpResponse))
                } else {
                    return .success(())
                }
            }
            .responseData { response in
                guard let data = response.data else {
                    completion(.failure(error: WebServiceProtocolError.server))
                    return
                }
                switch response.result {
                case .success(_):
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(Output.self, from: data)
                        completion(.success(modelData: result))
                    } catch {
                        completion(.failure(error: WebServiceProtocolError.serializationError))
                    }
                case .failure(_):
                    completion(.failure(error: WebServiceProtocolError.parsingFail(error: "Occurs an error with the data")))
                }
                
            }
    }
    
    
}


private extension APIClient {
    func validateConnectInternet() -> Bool {
        if let network = NetworkReachabilityManager() {
            return network.isReachable
        }
        return false
    }
    
    func isOccuringAnError(response: HTTPURLResponse) -> Bool {
        return  [401, 403, 404, 405, 409].contains(response.statusCode) || (500..<600 ~= response.statusCode)
    }
    
    func getError(response: HTTPURLResponse) -> WebServiceProtocolError {
        if (500..<600 ~= response.statusCode) {
            return .server
        } else {
            return .parsingFail(error: response.description)
        }
    }
}

private extension DataRequest {
    func logRequest() -> Self {
        responseData { response in
            print(response.debugDescription)
        }
        return self
    }
}
