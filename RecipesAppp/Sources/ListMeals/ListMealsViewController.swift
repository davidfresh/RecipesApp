//
//  ListMealsViewController.swift
//  RecipesAppp
//
//  Created by David on 18/08/23.
//

import Foundation
import UIKit

class ListMealsViewController: BaseViewController {
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
    
    private let mealsView: UIView = {
        let mealsView = UIView()
        mealsView.translatesAutoresizingMaskIntoConstraints = false
        mealsView.backgroundColor = .white
        return mealsView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = Localizable.searchTitle.localized
        searchBar.showsCancelButton = true
        return searchBar
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
    
    
    private lazy var presenter: ListMealsContract.Presenter = {
        let mealsUseCase = MealsInjector.provideMealsUseCase()
        
        return ListMealsPresenter(view: self,
                                  navigator: ListMealsNavigator(viewController: self),
                                  mealsUseCase: mealsUseCase)
    }()
    
    private var listMeals: [ListMealsViewModel]?
    
    override func loadView() {
        super.loadView()
        createSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        presenter.getListMeals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        title = Localizable.navigationTitleListMealsView.localized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private extension ListMealsViewController {
    func createSubviews() {
        view.backgroundColor = .white
        addViewsToMealsView()
        addConstraintsInMealsView()
        addViews()
        addConstraintsForViews()
    }
    
    func addViewsToMealsView() {
        mealsView.addSubview(tableView)
    }
    
    func addConstraintsInMealsView() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mealsView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: mealsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mealsView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: mealsView.bottomAnchor)
        ])
    }
    
    func addViews() {
        view.addSubview(searchBar)
        view.addSubview(mealsView)
        view.addSubview(activityIndicator)
    }
    
    func addConstraintsForViews() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            mealsView.topAnchor.constraint(equalTo: searchBar.topAnchor, constant: 60.0),
            mealsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mealsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mealsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupViews() {
        setActivityIndicator(activityIndicator)
        setupTableView()
        setupSearchBarView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        MealTableViewCell.registerCellForTable(tableView)
    }
    
    func setupSearchBarView() {
        searchBar.delegate = self
    }
    
    func updateViews(meals: [ListMealsViewModel]) {
        listMeals = meals
        tableView.reloadData()
    }
}

extension ListMealsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listMeals = listMeals else { return 0 }
        return listMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MealTableViewCell.reuseIdentifier, for: indexPath) as? MealTableViewCell else {
            return UITableViewCell()
        }
        guard let meal = listMeals?[indexPath.row] else {
            return cell
        }
        cell.fill(meal: meal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let IDMeal = listMeals?[indexPath.row].IDMeal ?? ""
        presenter.didTapMeal(IDMeal: IDMeal)
    }
}

extension ListMealsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 3 {
            presenter.filterMealsBy(text: searchText.lowercased())
        } else if searchText == "" {
            presenter.getListMeals()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        presenter.getListMeals()
    }
}

extension ListMealsViewController: ListMealsContract.View {
    func render(state: ListMealsViewState) {
        switch state {
        case .clear:
            break
        case .loading:
            showLoading()
        case .render(let meals):
            hideLoading()
            updateViews(meals: meals)
        case .error(let error):
            hideLoading()
            showAlertView(error: error) { [weak self] (_) in
                self?.presenter.getListMeals()
            }
            
        }
    }
    
    
}
