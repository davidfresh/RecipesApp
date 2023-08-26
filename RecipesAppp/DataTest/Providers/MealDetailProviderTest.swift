//
//  MealDetailProviderTest.swift
//  RecipesApppTests
//
//  Created by David on 25/08/23.
//

import XCTest
@testable import RecipesAppp

final class MealDetailProviderTest: XCTestCase {
    private var provider: MealDetailsProviderMock!
    private var data: Data!
    private var mealDetail: MealsDetailEntity!
    private lazy var mockDataTests = DataTestsMock()
    
    override func setUp() {
        super.setUp()
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "MealDetails"),
              let data = mockDataTests.convertURLToData(url: url),
              let detail = try? JSONDecoder().decode(MealsDetailEntity.self, from: data) else {
            return
        }
        self.data = data
        self.mealDetail = detail
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMealDetailParseSuccess() {
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "MealDetails") else {
            XCTFail("Couldn't get json file")
            return
        }
        guard let data = mockDataTests.convertURLToData(url: url) else {
            XCTFail("Couldn't load data")
            return
        }
        do {
            let result = try JSONDecoder().decode(MealsDetailEntity.self, from: data)
            XCTAssertEqual(result.meals.count, 1)
        } catch {
            XCTFail("Couldn't get object from data")
        }
    }
    
    func testMealDetailParseError() {
        let expectation = XCTestExpectation(description: "Parse  meal detail with error")
        guard let url = mockDataTests.getLocalURLPathOfMockJSONBy(nameFile: "MealDetailsError") else {
            XCTFail("Couldn't get json file")
            return
        }
        guard let data = mockDataTests.convertURLToData(url: url) else {
            XCTFail("Couldn't load data")
            return
        }
        do {
            let _ = try JSONDecoder().decode(MealsDetailEntity.self, from: data)
            XCTFail("Unexpected error")
        } catch {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetMealDetailWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch meal detail")
        provider = MealDetailsProviderMock(result: .success(data))
        provider.getMealDetails(IDMeal: "") { (result) in
            switch result {
            case .success(let dataMealDetail):
                let mealDetail = try? self.mealDetail.toDomain()
                XCTAssertEqual(dataMealDetail.results.first?.nameOfMeal , mealDetail?.results.first?.nameOfMeal)
                XCTAssertEqual(dataMealDetail.results.first?.instructions, mealDetail?.results.first?.instructions)
                XCTAssertEqual(dataMealDetail.results.first?.strIngredient1, mealDetail?.results.first?.strIngredient1)
                XCTAssertEqual(dataMealDetail.results.first?.strMeasure1, mealDetail?.results.first?.strMeasure1)
                
                XCTAssertEqual(dataMealDetail.results.count, mealDetail?.results.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected error")
            }
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testGetMealDetailWithError() {
        let expectation = XCTestExpectation(description: "Fetch  meal detail with error")
        let errorData = Data()
        provider = MealDetailsProviderMock(result: .success(errorData))
        provider.getMealDetails(IDMeal: "") { (result) in
            switch result {
            case .success:
                XCTFail("Unexpected error")
            case .failure(let error):
                if let error = error as? MealDetailsProviderMockContractError {
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

