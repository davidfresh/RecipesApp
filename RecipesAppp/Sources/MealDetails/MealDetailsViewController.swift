//
//  MealDetailsViewController.swift
//  RecipesAppp
//
//  Created by David on 21/08/23.
//

import UIKit
import Foundation

class MealDetailsViewController: BaseViewController {
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.tintColor = .black
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            // Fallback on earlier versions
            activityIndicator.style = .whiteLarge
        }
        return activityIndicator
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mealNameLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 36)
        return titleLabel
    }()
    
    private let instructionsLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        titleLabel.font = .systemFont(ofSize: 16)
        return titleLabel
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.allowsSelection = true
        tableView.backgroundColor = .white
        return tableView
    }()
    
    private lazy var presenter: MealDetailsContract.Presenter = {
        let mealDetailUseCase = MealDetailsInjector.provideMealDetailUseCase()
        let navigator = MealDetailsNavigator(viewController: self)
        
        return MealDetailsPresenter(view: self,
                                    navigator: navigator,
                                    mealsUseCase: mealDetailUseCase)
    }()
    
    var IDMealDetail = ""
    private var mealDetailViewModel: MealDetailsViewModel?
    
    override func loadView() {
        super.loadView()
        createSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.getMealDetails(IDMeal: IDMealDetail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackButton(action: #selector(didTapBackButton))
    }
}
private extension MealDetailsViewController {
    
    func createSubviews() {
        view.backgroundColor = .white
        addViews()
        addConstraintsForViews()
    }

    func addViews() {
        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        scrollView.addSubview(tableView)

    }
    
    func addConstraintsForViews() {
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupViews() {
        setActivityIndicator(activityIndicator)
        setupTableView()
        setupStackiew()
    }
    
    func setupStackiew() {
        stackView.addArrangedSubview(mealNameLabel)
        stackView.addArrangedSubview(instructionsLabel)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        MealIngredientsTableViewCell.registerCellForTable(tableView)
    }
    
    func updateViews(mealDetail: MealDetailsViewModel) {
        mealDetailViewModel = mealDetail
        mealNameLabel.text = mealDetail.nameOfMeal
        instructionsLabel.text = mealDetail.instructions
        tableView.reloadData()
    }
    
    @objc func didTapBackButton() {
        presenter.goToPreviousView()
    }
}

extension MealDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listOfIngredients = mealDetailViewModel?.ingredients else { return 0 }
        return listOfIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealIngredientsTableViewCell.reuseIdentifier, for: indexPath) as? MealIngredientsTableViewCell else {
            return UITableViewCell()
        }
        guard let ingredients = mealDetailViewModel?.ingredients[indexPath.row] else {
            return cell
        }
        cell.fill(mealDetailIngredients: ingredients)
        return cell
    }
}

extension MealDetailsViewController: MealDetailsContract.View {
    func render(state: MealDetailsViewState) {
        switch state {
        case .clear:
            break
        case .loading:
            showLoading()
        case .render(let mealDetailViewModel):
            updateViews(mealDetail: mealDetailViewModel)
            hideLoading()
        case .error(_):
            hideLoading()
        }
    }
    
    
}
