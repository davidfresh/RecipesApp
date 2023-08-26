//
//  MealDetailsPresenter.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation
final class MealDetailsPresenter {
    private weak var view: MealDetailsContract.View?
    private let mealDetailsUseCase: MealDetailsUseCaseContract
    private let navigator: MealDetailsContract.Navigator
    
    private var viewState: MealDetailsViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.render(state: viewState)
        }
    }
    
    init(view: MealDetailsContract.View?,
         navigator: MealDetailsContract.Navigator,
         mealsUseCase: MealDetailsUseCaseContract) {
        self.view = view
        self.mealDetailsUseCase = mealsUseCase
        self.navigator = navigator
    }
}

// Presenter
extension MealDetailsPresenter: MealDetailsContract.Presenter {
    func getMealDetails(IDMeal: String) {
        viewState = .loading
        mealDetailsUseCase.getMealDetails(IDMeal: IDMeal) { [weak self] result in
            switch result {
            case .success(let mealDetail):
                self?.createMealDetailViewModel(mealDetail: mealDetail)
            case .failure(let error):
                var message = error.localizedDescription
                if let errorUseCase = error as? MealDetailsUseCaseError,
                   let errorDescription = errorUseCase.errorDescription {
                    message = errorDescription
                }
                self?.viewState = .error(error: message)
            }
        }
    }
    
    func goToPreviousView() {
        navigator.presentPreviousView()
    }
}

private extension MealDetailsPresenter {
    
    func createMealDetailViewModel(mealDetail: MealsDetail) {
        guard let mealDetail = mealDetail.results.first else {
            return
        }
        var ingredientsAndMeasure: [MealDetailsIngredientsAndMeasureViewModel] = []
        
        for (ingredient, measure) in zip(mealDetail.arrayOfIngredients(), mealDetail.arrayOfMeasures()) {
            if ingredient != "" && measure != "" {
                let ingredientViewModel = MealDetailsIngredientsAndMeasureViewModel(nameOfIngredient:ingredient,
                                                                                    measureOfIngredient: measure)
                ingredientsAndMeasure.append(ingredientViewModel)
            }
        }
        
        let mealDetailVM = MealDetailsViewModel(nameOfMeal: mealDetail.nameOfMeal,
                                                instructions: mealDetail.instructions,
                                                ingredients: ingredientsAndMeasure)
                            
        viewState = .render(mealDetails: mealDetailVM)
    }
}
