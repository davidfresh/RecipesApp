//
//  MealIngredientsTableViewCell.swift
//  RecipesAppp
//
//  Created by David on 22/08/23.
//

import Foundation
import UIKit

final class MealIngredientsTableViewCell: UITableViewCell {
    
    private let ingredientLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
        return titleLabel
    }()
    
    private let measureLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
        return titleLabel
    }()
    
    private var mealDetailIngredients: MealDetailsIngredientsAndMeasureViewModel?
    
    static let reuseIdentifier = String(describing: self)
    
    static func registerCellForTable(_ tableView: UITableView) {
        tableView.register(MealIngredientsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(mealDetailIngredients: MealDetailsIngredientsAndMeasureViewModel) {
        self.mealDetailIngredients = mealDetailIngredients
        setupCell()
    }
}

private extension MealIngredientsTableViewCell {
    func createViews() {
        selectionStyle = .gray
        contentView.backgroundColor = .white
        contentView.addSubview(ingredientLabel)
        contentView.addSubview(measureLabel)
        addConstraintsForViews()
    }
    
    func addConstraintsForViews() {
        NSLayoutConstraint.activate([
            ingredientLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            ingredientLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            ingredientLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            ingredientLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            measureLabel.leadingAnchor.constraint(equalTo: ingredientLabel.trailingAnchor, constant: 8),
            measureLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            measureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupCell() {
        guard let viewModel = mealDetailIngredients else {
            ingredientLabel.isHidden = true
            measureLabel.isHidden = true
            return
        }
        ingredientLabel.text = viewModel.nameOfIngredient
        measureLabel.text = viewModel.measureOfIngredient
    }
}
