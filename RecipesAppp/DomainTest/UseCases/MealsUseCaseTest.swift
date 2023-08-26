//
//  MealsUseCaseTest.swift
//  RecipesAppp
//
//  Created by David on 25/08/23.
//

import XCTest
@testable import RecipesAppp

final class MealsUseCaseTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetListMealsUseCaseWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch list meals")
        let listMeals = getListOfMeals()
        let useCase = MealsUseCaseMock(meals: listMeals)
        useCase.getListOfMeals(categoryName: "Dessert") { (result) in
            switch result {
            case .success(let dataMeals):
                XCTAssertEqual(dataMeals.first, listMeals?.results.first(where: { $0.IDMeal == dataMeals.first?.IDMeal }))
                XCTAssertEqual(dataMeals.count, listMeals?.results.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected error")
            }
        }
    }
    
    func testGetListMealsUseCaseWithError() {
        let expectation = XCTestExpectation(description: "Fetch list meals with error")
        let useCase = MealsUseCaseMock(meals: nil)
        useCase.getListOfMeals(categoryName: "Dessert") { (result) in
            switch result {
            case .success:
                XCTFail("Unexpected error")
            case .failure(let error):
                if let error = error as? MealsUseCaseMockError {
                    XCTAssertEqual(error, .generic)
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected error")
                }
            }
        }
    }
    
    func testOrderFlightsSuccess() {
        guard let listMeals = getListOfMeals() else { return }
        let testSortedMeals = orderMeals(listMeals)
        let useCase = MealsUseCaseMock(meals: listMeals)
        XCTAssertEqual(testSortedMeals, useCase.orderMeals(listMeals))
    }
    
    func testOrderFlightsError() {
        guard let listMeals = getListOfMeals() else { return }
        let testSortedMeals = listMeals.results.sorted(by: { $0 > $1 }).compactMap { $0 }
        let useCase = MealsUseCaseMock(meals: nil)
        XCTAssertNotEqual(testSortedMeals, useCase.orderMeals(listMeals))
    }
}

private extension MealsUseCaseTest {
    func getListOfMeals() -> Meals? {
        var meals = [Meal]()
        
        let mealOne = Meal(nameOfMeal: "Apam balik",
                           imageOfMeal: getImageURL(stringUrl: "https://www.themealdb.com//images//media//meals//adxcbq1619787919.jpg"),
                           IDMeal: "53049")
        
        let mealTwo = Meal(nameOfMeal: "Apple & Blackberry Crumble",
                           imageOfMeal: getImageURL(stringUrl: "https://www.themealdb.com//images//media//meals//xvsurr1511719182.jpg"),
                           IDMeal: "52893")
        
        let mealThree = Meal(nameOfMeal: "Apple Frangipan Tart",
                           imageOfMeal: getImageURL(stringUrl: "https://www.themealdb.com//images//media//meals//wyrqqq1468233628.jpg"),
                           IDMeal: "52768")
        meals.append(mealOne)
        meals.append(mealTwo)
        meals.append(mealThree)
        
        return Meals(results: meals)
    }
    
    func getImageURL(stringUrl: String) -> URL? {
        return URL(string: stringUrl)
    }
    
    func orderMeals(_ meals: Meals) -> [Meal] {
        let sortedMeals = meals.results.sorted { $0 < $1 }
        return sortedMeals.compactMap { $0}
    }
}
