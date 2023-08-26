//
//  MealsInjector.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation

public class MealsInjector {
    
    public static func provideMealsUseCase() -> MealsUseCaseContract {
        return MealsUseCase(provider: MealsProvider())
    }
}
