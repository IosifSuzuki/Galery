//
//  CategorieTableViewCell.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var previewPhotoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var createdByLabel: UILabel!
    
    //MARK: - Private Properties
    
    private(set) var categorie: Category?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupAppearance()
    }
    
    // MARK: - Public Methods
    
    func setup(categorie: Category) {
        self.categorie = categorie
        
        titleLabel.text = categorie.title
        descriptionLabel.text = categorie.about
        let showCreatedByLabel = UserDefaults.standard.value(forKey: Constants.KeyPath.displayCreatedDate.rawValue) as? Bool ?? true
        createdByLabel.isHidden = !showCreatedByLabel
        createdByLabel.text = CategoryTableViewCell.createPrettyData(from: categorie.createdBy)
    }
    
}

// MARK: - Private Methods
extension CategoryTableViewCell {
    
    private func setupAppearance() {
        previewPhotoImageView.layer.cornerRadius = 8
        previewPhotoImageView.layer.masksToBounds = true
    }
    
    private static func createPrettyData(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ConfigurationManager.shared.templateFormat ?? "YYYY MM dd"
        return dateFormatter.string(from: date)
    }
    
}
