//
//  SettingsViewController.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

protocol SettingsDelegate: class {
    
    func updateDataSource()
    
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsDelegate?
    
    @IBOutlet weak private var displayDateSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayDateSwitch.isOn = UserDefaults.standard.bool(forKey: Constants.KeyPath.displayCreatedDate.rawValue)
    }
    
    @IBAction private func displayDateAction(_ sender: UISwitch) {
        UserDefaults.standard.setValue(sender.isOn, forKey: Constants.KeyPath.displayCreatedDate.rawValue)
    }
    
    @IBAction private func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true) { [unowned self] in
            delegate?.updateDataSource()
        }
    }

}
