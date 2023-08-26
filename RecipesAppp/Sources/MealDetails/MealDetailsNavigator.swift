//
//  MealDetailsNavigator.swift
//  RecipesAppp
//
//  Created by David on 24/08/23.
//

import Foundation
import UIKit

final class MealDetailsNavigator {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
}

extension MealDetailsNavigator: MealDetailsContract.Navigator {
    func presentPreviousView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
