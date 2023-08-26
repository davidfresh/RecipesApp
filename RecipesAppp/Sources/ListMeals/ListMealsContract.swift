//
//  ListMealsContract.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
enum ListMealsContract {
    typealias Presenter = ListMealsPresenterContract
    typealias View = ListMealsViewContract
    typealias Navigator = ListMealsNavigatorContract
}

protocol ListMealsPresenterContract {
    func getListMeals()
    func filterMealsBy(text: String)
    func didTapMeal(IDMeal: String)
}

protocol ListMealsViewContract: AnyObject {
    func render(state: ListMealsViewState)
}

protocol ListMealsNavigatorContract {
    func presentMealDetail(IDMeal: String)
}

enum ListMealsViewState: Equatable {
    case clear
    case loading
    case render(meals: [ListMealsViewModel])
    case error(error: String)
}
