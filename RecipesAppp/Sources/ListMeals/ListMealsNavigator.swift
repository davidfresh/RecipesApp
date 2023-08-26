//
//  ListMealsNavigator.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
import UIKit

final class ListMealsNavigator {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension ListMealsNavigator: ListMealsContract.Navigator {
    func presentMealDetail(IDMeal: String) {
        let mealDetailVC = MealDetailsViewController()
        mealDetailVC.IDMealDetail = IDMeal
        viewController?.navigationController?.pushViewController(mealDetailVC, animated: true)
    }
    
}
