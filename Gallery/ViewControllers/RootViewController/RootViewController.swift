//
//  RootViewController.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

class RootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupAppearance()
    }

}

extension RootViewController {
    
    private func setupAppearance() {
        navigationBar.tintColor = .white
        navigationBar.barTintColor = Constants.mainColor
    }
    
}
