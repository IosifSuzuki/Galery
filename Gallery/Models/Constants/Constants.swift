//
//  Constants.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

struct Constants {
    
    static let mainColor = #colorLiteral(red: 0.4078431373, green: 0.7568627451, blue: 0.7882352941, alpha: 1)
    
    enum Segue: String {
        case addNewCategory = "addNewCategory"
        case showCollectionOfPhotos = "ShowCollectionOfPhotos"
        case showSettings = "showSettings"
    }
    
    enum KeyPath: String {
        case displayCreatedDate
    }
}
