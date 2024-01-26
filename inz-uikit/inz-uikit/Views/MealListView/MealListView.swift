//
//  ViewController.swift
//  inz-uikit
//
//  Created by Paweł Dera on 06/11/2023.
//

import UIKit

struct Meal: Identifiable {
    let id: UUID = UUID()
    let image: UIImage
    let name: String
    let cookingTime: Int
}

let meals = [
    Meal(image: UIImage(resource: .foodCake), name: "Cake", cookingTime: 45),
    Meal(image: UIImage(resource: .foodBurger), name: "Burger", cookingTime: 60),
    Meal(image: UIImage(resource: .foodPasta), name: "Pasta", cookingTime: 75),
    Meal(image: UIImage(resource: .foodSalad), name: "Salad", cookingTime: 30),
    Meal(image: UIImage(resource: .foodFishSoup), name: "Fish Soup", cookingTime: 45),
    Meal(image: UIImage(resource: .foodIceCream), name: "Ice Cream", cookingTime: 60),
    Meal(image: UIImage(resource: .foodPumpkinSoup), name: "Pumpkin Soup", cookingTime: 120),
    Meal(image: UIImage(resource: .foodChickenWings), name: "Chicken Wings", cookingTime: 75)
]

final class MealListView: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.rowHeight = 85
        tableView.separatorInset = .init(top: 0, left: 100, bottom: 0, right: 0)
        tableView.register(MealCell.self, forCellReuseIdentifier: "MealCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        
        title = "Pick your food"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension MealListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mealCell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as? MealCell else { fatalError() }
        
        mealCell.mealImageView.image = meals[indexPath.row].image
        mealCell.mealName.text = meals[indexPath.row].name
        mealCell.mealCookingTime.text = "\(meals[indexPath.row].cookingTime) min cooking time"
        
        return mealCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(MealDetailsView(meal: meals[indexPath.row]), animated: true)
    }
}

class MealDetailsView: UIViewController {
    
    var meal: Meal
    
    init(meal: Meal) {
        self.meal = meal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var mealImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 64
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    var mealName: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var mealCookingTime: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var addToFavoritesButton: UIButton = {
        let button = UIButton(configuration: .borderedTinted())
        button.setTitle("Add to favorites", for: .normal)
        let heartImage = UIImage(systemName: "heart.fill")?.withConfiguration(UIImage.SymbolConfiguration(scale: .medium))
        button.setImage(heartImage, for: .normal)
        button.configuration?.imagePadding = 10
        button.configuration?.cornerStyle = .medium
        button.tintColor = .systemPink
        button.semanticContentAttribute = .forceRightToLeft
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "add-to-favorites-button"
        return button
    }()
    
    func addToFavoritesButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self = self else { return }
            self.mealImageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) {  [weak self] _ in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                self.mealImageView.transform = .identity
            }, completion: nil)
        }
    }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = meal.name
        mealImageView.image = meal.image
        mealName.text = meal.name
        mealCookingTime.text = "\(meal.cookingTime) min cooking time"
        
        let action = UIAction { [weak self] _ in
            self?.addToFavoritesButtonTapped()
        }
        addToFavoritesButton.addAction(action, for: .primaryActionTriggered)
        
        view.addSubview(mealImageView)
        view.addSubview(mealName)
        view.addSubview(mealCookingTime)
        view.addSubview(addToFavoritesButton)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            mealImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            mealImageView.heightAnchor.constraint(equalToConstant: 320.0),
            
            mealName.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 16.0),
            mealName.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            mealName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            mealCookingTime.topAnchor.constraint(equalTo: mealName.bottomAnchor, constant: 16.0),
            mealCookingTime.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            mealCookingTime.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            
            addToFavoritesButton.topAnchor.constraint(equalTo: mealCookingTime.bottomAnchor, constant: 16.0),
            addToFavoritesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 96.0),
            addToFavoritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -96.0),
            addToFavoritesButton.heightAnchor.constraint(equalToConstant: 48.0),
        ])
    }
}


class MealCell: UITableViewCell {
    
    var mealImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect())
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var mealName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var mealCookingTime: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "MealCell")
        
        accessoryType = .disclosureIndicator
        
        stackView.addArrangedSubview(mealName)
        stackView.addArrangedSubview(mealCookingTime)
        addSubview(mealImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            mealImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            mealImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            mealImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
            mealImageView.widthAnchor.constraint(equalToConstant: 64),
            mealImageView.heightAnchor.constraint(equalToConstant: 64),
            
            stackView.leadingAnchor.constraint(equalTo: mealImageView.trailingAnchor, constant: 24.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
