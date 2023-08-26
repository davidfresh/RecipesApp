//
//  DataTestMock.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import Foundation

final class DataTestsMock {
    func getLocalURLPathOfMockJSONBy(nameFile: String) -> URL? {
        let bundle = Bundle(for: type(of: self))
        return bundle.url(forResource: nameFile, withExtension: "json")
    }
    
    func convertURLToData(url: URL) -> Data? {
        return try? Data(contentsOf: url)
    }
}
