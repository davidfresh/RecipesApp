//
//  MealDetailsInjector.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import Foundation

public class MealDetailsInjector {
    
    public static func provideMealDetailUseCase() -> MealDetailsUseCaseContract {
        return MealDetailsUseCase(provider: MealDetailsProvider())
    }
}
