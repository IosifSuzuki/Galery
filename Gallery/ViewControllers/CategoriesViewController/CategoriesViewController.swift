//
//  ViewController.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

class CategoriesViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var emptyStateView: UIStackView!
    @IBOutlet private weak var addControl: UIControl!
    
    // MARK: - Private Properties
    
    private var dataSource: [Category]!
    private var deleteCategories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        setupAppearance()
    }
    
    // MARK: - Actions
    
    @IBAction private func saveAction(_ sender: AnyObject) {
        MyFileManager.saveData(categories: dataSource)
        
        for category in deleteCategories {
            for photoItem in category.references {
                MyFileManager.removeImage(by: photoItem.pathToPhoto)
            }
        }
    }
    
    @IBAction private func addAction(_ sender: AnyObject) {
        performSegue(withIdentifier: Constants.Segue.addNewCategory.rawValue, sender: sender)
    }
    
    
    // MARK: - Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.Segue.addNewCategory.rawValue:
            guard let destinationNC = (segue.destination as? UINavigationController) else {
                return
            }
            guard let destinationVC = destinationNC.topViewController as? AddNewCategoryViewController else {
                return
            }
            destinationVC.delegate = self
        case Constants.Segue.showCollectionOfPhotos.rawValue:
            guard let destinationVC = (segue.destination as? CollectionOfPhotosViewController) else {
                return
            }
            guard let category = sender as? Category else {
                return
            }
            destinationVC.delegate = self
            destinationVC.category = category
        case Constants.Segue.showSettings.rawValue:
            guard let destinationNC = (segue.destination as? UINavigationController) else {
                return
            }
            guard let destinationVC = destinationNC.topViewController as? SettingsViewController else {
                return
            }
            destinationVC.delegate = self
        default:
            break
        }
    }
    
}

extension CategoriesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyStateView.isHidden = !dataSource.isEmpty
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryTableViewCell.self)) as! CategoryTableViewCell
        let categorie = dataSource[indexPath.row]
        
        cell.setup(categorie: categorie)
        
        let isLastCell = tableView.numberOfRows(inSection: 0) == indexPath.row + 1
        
        if isLastCell {
            cell.separatorInset = .zero
            cell.layoutMargins = .zero
            cell.preservesSuperviewLayoutMargins = false
        } else {
            cell.preservesSuperviewLayoutMargins = true
        }
        
        return cell
    }
    
}

extension CategoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = dataSource[indexPath.row]
        performSegue(withIdentifier: Constants.Segue.showCollectionOfPhotos.rawValue, sender: category)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let category = dataSource[indexPath.row]
            deleteCategories.append(category)
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }
    
}

extension CategoriesViewController: AddNewCategoryDelegate {
    
    func add(newCategory category: Category) {
        dataSource.append(category)
        let newRow = tableView.numberOfRows(inSection: 0)
        tableView.insertRows(at: [IndexPath(row: newRow, section: 0)], with: .top)
    }
    
}

extension CategoriesViewController: SettingsDelegate {
    
    func updateDataSource() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
}

extension CategoriesViewController: AddNewImageDelegate {
    
    func addNewImage(category: Category) {
        guard let row = dataSource.firstIndex(where:{ currentCategory in
            return currentCategory.title == category.title && currentCategory.about == category.about
        }) else {
            return
        }
        
        dataSource[row] = category
    }
    
}

extension CategoriesViewController {
    
    private func setupAppearance() {
        title = "Photo categories"
        registerCell(withClass: CategoryTableViewCell.self)
        tableView.tableFooterView = UIView(frame: .zero)
        addControl.layer.cornerRadius = addControl.bounds.midY
        addControl.layer.shadowColor = UIColor.black.cgColor
        addControl.layer.shadowOpacity = 0.4
        addControl.layer.shadowRadius = 4
        addControl.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    private func loadData() {
        dataSource = MyFileManager.loadData()
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    private func registerCell<T: UITableViewCell>(withClass type: T.Type) {
        let nibName = String(describing: type)
        
        tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
}

