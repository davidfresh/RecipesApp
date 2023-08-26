//
//  MealTableViewCell.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
import UIKit

final class MealTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
        return titleLabel
    }()
    
    
    private let mealImageView: UIImageView = {
        let mealImageView = UIImageView()
        mealImageView.frame =  CGRect(x: 0, y: 0, width: 60, height: 60)
        mealImageView.contentMode = .scaleAspectFit
        mealImageView.clipsToBounds = true
        return mealImageView
    }()
    
    private var meal: ListMealsViewModel?
    
    static let reuseIdentifier = String(describing: self)
    
    static func registerCellForTable(_ tableView: UITableView) {
        tableView.register(MealTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fill(meal: ListMealsViewModel) {
        self.meal = meal
        setupCell()
    }
}

private extension MealTableViewCell {
    func createViews() {
        selectionStyle = .gray
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(mealImageView)
        addConstraintsForViews()
    }
    
    func addConstraintsForViews() {
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            mealImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5.0),
            mealImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setupCell() {
        guard let viewModel = meal else {
            titleLabel.isHidden = true
            mealImageView.isHidden = true
            return
        }
        titleLabel.text = viewModel.nameOfMeal
        if let url = viewModel.imageOfMeal {
            mealImageView.loadImage(from: url)
        }
    }
}
