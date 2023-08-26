//
//  APIRouter.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
import Alamofire

private enum URLs: String {
    case listDessert = "https://themealdb.com/api/json/v1/1/filter.php?"
    case mealDetail = "https://themealdb.com/api/json/v1/1/lookup.php?"
}

public enum APIRouter: URLRequestConvertible {
    case getListDessert(categoryName: String)
    case getlMealDetails(idMeal: String)
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        return .get
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .getListDessert(categoryName: let cagegoryName):
            return "\(URLs.listDessert.rawValue)c=\(cagegoryName)"
        case .getlMealDetails(let idMeal):
            return "\(URLs.mealDetail.rawValue)i=\(idMeal)"
        }
    }
    
    // MARK: - URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {
        let url = try path.asURL()
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
