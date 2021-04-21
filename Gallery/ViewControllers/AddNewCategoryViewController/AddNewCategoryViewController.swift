//
//  AddNewCategoryViewController.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

protocol AddNewCategoryDelegate: class {
    
    func add(newCategory category: Category)
    
}

class AddNewCategoryViewController: UIViewController {
    
    @IBOutlet weak var containerOfTitleTextField: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var containerOfTextView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    // MARK: - Public Property
    
    weak var delegate: AddNewCategoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        titleTextField.becomeFirstResponder()
    }

    // MARK: - Action
    
    @IBAction private func cancelAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func doneAction(_ sender: AnyObject) {
        guard let title = titleTextField.text, let about = textView.text, !title.isEmpty, !about.isEmpty  else {
            return
        }
        dismiss(animated: true) { [unowned self] in
            let category = Category(
                title: title,
                about: textView.text,
                createdBy: Date(),
                references: []
            )
            delegate?.add(newCategory: category)
        }

    }
}

extension AddNewCategoryViewController {
    
    private func setupAppearance() {
        let containerViews = [
            containerOfTitleTextField,
            containerOfTextView,
        ] as! [UIView]
        for containerView in containerViews {
            containerView.layer.cornerRadius = 8
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = Constants.mainColor.cgColor
            containerView.layer.masksToBounds = true
        }
        
        let textViews = [
            titleTextField,
            textView,
        ] as! [UIView]
        for textView in textViews {
            textView.tintColor = Constants.mainColor
        }
        
    }
    
}
