//
//  MealsProviderTest.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import XCTest
@testable import RecipesAppp

final class MealsProviderTest: XCTestCase {
    private var provider: MealsProviderMock!
    private var data: Data!
    private var listOfMeals: MealsEntity!
    private lazy var mockDataTests = DataTestsMock()
    
    override func setUp() {
        super.setUp()
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "ListOfMeals"),
              let data = mockDataTests.convertURLToData(url: url),
              let list = try? JSONDecoder().decode(MealsEntity.self, from: data) else {
            return
        }
        self.data = data
        self.listOfMeals = list
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testListMealsParseSuccess() {
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "ListOfMeals") else {
            XCTFail("Couldn't get json file")
            return
        }
        guard let data = mockDataTests.convertURLToData(url: url) else {
            XCTFail("Couldn't load data")
            return
        }
        do {
            let result = try JSONDecoder().decode(MealsEntity.self, from: data)
            XCTAssertEqual(result.meals.count, 64)
        } catch {
            XCTFail("Couldn't get object from data")
        }
    }
    
    func testListMealsParseError() {
        let expectation = XCTestExpectation(description: "Parse list meals with error")
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "ListOfMealsError") else {
            XCTFail("Couldn't get json file")
            return
        }
        guard let data = mockDataTests.convertURLToData(url: url) else {
            XCTFail("Couldn't load data")
            return
        }
        do {
            let _ = try JSONDecoder().decode(MealsEntity.self, from: data)
            XCTFail("Unexpected error")
        } catch {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetListMealsWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch list meals")
        provider = MealsProviderMock(result: .success(data))
        provider.getListMeals(categoryName: "") { (result) in
            switch result {
            case .success(let dataListMeals):
                let listMeals = try? self.listOfMeals.toDomain()
                XCTAssertEqual(dataListMeals.results.first?.nameOfMeal, listMeals?.results.first?.nameOfMeal)
                XCTAssertEqual(dataListMeals.results.first?.IDMeal, listMeals?.results.first?.IDMeal)
                XCTAssertEqual(dataListMeals.results.first?.imageOfMeal, listMeals?.results.first?.imageOfMeal)
                
                XCTAssertEqual(dataListMeals.results.count, listMeals?.results.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected error")
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetListMealsWithError() {
        let expectation = XCTestExpectation(description: "Fetch list meals with error")
        let errorData = Data()
        provider = MealsProviderMock(result: .success(errorData))
        provider.getListMeals(categoryName: "") { (result) in
            switch result {
            case .success:
                XCTFail("Unexpected error")
            case .failure(let error):
                if let error = error as? MealsProviderMockProviderContractError {
                    XCTAssertEqual(error, .generic)
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected error")
                }
            }
        }
        wait(for: [expectation], timeout: 3)
    }
}
