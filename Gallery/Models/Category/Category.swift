//
//  Categorie.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import Foundation

class Category: NSObject, NSSecureCoding {
    
    let title: String
    let about: String
    let createdBy: Date
    var references: [PhotoItem]
    
    init(title: String, about: String, createdBy: Date, references: [PhotoItem]) {
        self.title = title
        self.about = about
        self.createdBy = createdBy
        self.references = references
        
        super.init()
    }
    
    required convenience init?(coder: NSCoder) {
        let title = coder.decodeObject(forKey: KeyPath.title.rawValue) as! String
        let about = coder.decodeObject(forKey: KeyPath.about.rawValue) as! String
        let createdBy = coder.decodeObject(forKey: KeyPath.createdBy.rawValue) as! Date
        let references = coder.decodeObject(forKey: KeyPath.references.rawValue) as! [PhotoItem]
        
        self.init(title: title, about: about, createdBy: createdBy, references: references)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey: KeyPath.title.rawValue)
        coder.encode(about, forKey: KeyPath.about.rawValue)
        coder.encode(createdBy, forKey: KeyPath.createdBy.rawValue)
        coder.encode(references, forKey: KeyPath.references.rawValue)
    }
    
    static var supportsSecureCoding: Bool {
      return true
    }
    
    private enum KeyPath: String {
        case title
        case about
        case createdBy
        case references
    }
    
}
