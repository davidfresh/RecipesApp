//
//  Localizable.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
enum Localizable: String {
    // MARK: List meals
    case searchTitle = "SEARCH_PALCEHOLDER"
    // MARK: List meals View
    case navigationTitleListMealsView = "NAVIGATION_TITLE_LIST_MEALS_VIEW"
    // MARK: Alert
    case alertTitleError = "ALERT_TITLE_ERROR"
    case alertButtonOK = "ALERT_BUTTON_OK"
    
    var localized: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
