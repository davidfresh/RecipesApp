//
//  MealDetailsUseCaseTest.swift
//  RecipesAppp
//
//  Created by David on 25/08/23.
//

import XCTest
@testable import RecipesAppp

final class MealDetailsUseCaseTest: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMealDetailsUseCaseWithSuccess() {
        let expectation = XCTestExpectation(description: "Fetch meal detail")
        let mealDetail = getMealDetail()
        let useCase = MealsDetailUseCaseMock(mealDetail: mealDetail)
        useCase.getMealDetails(IDMeal: "") { (result) in
            switch result {
            case .success(let dataMealDetail):
                XCTAssertEqual(dataMealDetail.results.first, mealDetail.results.first(where: { $0.instructions == dataMealDetail.results.first?.instructions }))
                XCTAssertEqual(dataMealDetail.results.count, mealDetail.results.count)
                expectation.fulfill()
            case .failure:
                XCTFail("Unexpected error")
            }
        }
    }
    
    func testMealDetailsUseCaseWithError() {
        let expectation = XCTestExpectation(description: "Fetch meal detail")
        let useCase = MealsDetailUseCaseMock(mealDetail: nil)
        useCase.getMealDetails(IDMeal: "") { (result) in
            switch result {
            case .success:
                XCTFail("Unexpected error")
            case .failure(let error):
                if let error = error as? MealsDetailUseCaseMockError {
                    XCTAssertEqual(error, .generic)
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected error")
                }
            }
        }
    }
}

private extension MealDetailsUseCaseTest {
    func getMealDetail() -> MealsDetail {
        var mealDetails = [MealDetails]()
        
        let mealDetail = MealDetails(nameOfMeal: "Apple Frangipan Tart",
                                     instructions: "Preheat the oven to 200C/180C Fan/Gas 6.Put the biscuits in a large re-sealable freezer bag and bash with a rolling pin into fine crumbs.",
                                     strIngredient1: "digestive biscuits",
                                     strIngredient2: "butter",
                                     strIngredient3: "Bramley apples",
                                     strIngredient4: "",
                                     strIngredient5: "",
                                     strIngredient6: "",
                                     strIngredient7: "",
                                     strIngredient8: "",
                                     strIngredient9: "",
                                     strIngredient10: "",
                                     strIngredient11: "",
                                     strIngredient12: "",
                                     strIngredient13: "",
                                     strIngredient14: "",
                                     strIngredient15: "",
                                     strIngredient16: "",
                                     strIngredient17: "",
                                     strIngredient18: "",
                                     strIngredient19: "",
                                     strIngredient20: "",
                                     strMeasure1: "175g/6oz",
                                     strMeasure2: "75g/3oz",
                                     strMeasure3: "200g/7oz",
                                     strMeasure4: "",
                                     strMeasure5: "",
                                     strMeasure6: "",
                                     strMeasure7: "",
                                     strMeasure8: "",
                                     strMeasure9: "",
                                     strMeasure10: "",
                                     strMeasure11: "",
                                     strMeasure12: "",
                                     strMeasure13: "",
                                     strMeasure14: "",
                                     strMeasure15: "",
                                     strMeasure16: "",
                                     strMeasure17: "",
                                     strMeasure18: "",
                                     strMeasure19: "",
                                     strMeasure20: "")
        mealDetails.append(mealDetail)
        
        return  MealsDetail(results: mealDetails)
        
    }
}
