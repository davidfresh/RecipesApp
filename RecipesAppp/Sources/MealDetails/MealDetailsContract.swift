//
//  MealDetailsContract.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation

enum MealDetailsContract {
    typealias Presenter = MealDetailsPresenterContract
    typealias View = MealDetailsViewContract
    typealias Navigator = MealDetailsNavigatorContract
}

protocol MealDetailsPresenterContract {
    func getMealDetails(IDMeal: String)
    func goToPreviousView()
}

protocol MealDetailsViewContract: AnyObject {
    func render(state: MealDetailsViewState)
}

protocol MealDetailsNavigatorContract {
    func presentPreviousView()
}

enum MealDetailsViewState: Equatable {
    case clear
    case loading
    case render(mealDetails: MealDetailsViewModel)
    case error(error: String)
}
