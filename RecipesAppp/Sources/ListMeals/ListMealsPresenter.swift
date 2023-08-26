//
//  ListMealsPresenter.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
final class ListMealsPresenter {
    private weak var view: ListMealsContract.View?
    private let navigator: ListMealsContract.Navigator
    private let mealsUseCase: MealsUseCaseContract
    
    private var viewState: ListMealsViewState = .clear {
        didSet {
            guard oldValue != viewState else {
                return
            }
            view?.render(state: viewState)
        }
    }
    
    init(view: ListMealsContract.View?,
         navigator: ListMealsContract.Navigator,
         mealsUseCase: MealsUseCaseContract) {
        self.view = view
        self.navigator = navigator
        self.mealsUseCase = mealsUseCase
    }
}

private var mealsViewModel =  [ListMealsViewModel]()

// Presenter
extension ListMealsPresenter: ListMealsContract.Presenter {
    func didTapMeal(IDMeal: String) {
        navigator.presentMealDetail(IDMeal: IDMeal)
    }
    
    func filterMealsBy(text: String) {
        let filterMeals = mealsViewModel.filter { $0.nameOfMeal.lowercased().contains(text.lowercased()) }
        viewState = .render(meals: filterMeals)
    }
    
    func getListMeals() {
        viewState = .loading
        mealsUseCase.getListOfMeals(categoryName: "Dessert") { [weak self] result in
            switch result {
            case .success(let meals):
                self?.createListMealsViewModels(meals: meals)
            case .failure(let error):
                var message = error.localizedDescription
                if let errorUseCase = error as? MealsUseCaseError,
                   let errorDescription = errorUseCase.errorDescription {
                    message = errorDescription
                }
                self?.viewState = .error(error: message)
            }
        }
    }
}

private extension ListMealsPresenter {
    func createListMealsViewModels(meals: [Meal]) {
        var listMealsViewModel: [ListMealsViewModel] = []
        let _ =  meals.compactMap { meal in
            let meal = ListMealsViewModel(nameOfMeal: meal.nameOfMeal,
                                          imageOfMeal: meal.imageOfMeal,
                                          IDMeal: meal.IDMeal)
            listMealsViewModel.append(meal)
        }
        mealsViewModel = listMealsViewModel
        viewState = .render(meals: listMealsViewModel)
    }
}
