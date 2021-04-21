//
//  PhotoItem.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import Foundation

class PhotoItem: NSObject, NSSecureCoding {
    
    let pathToPhoto: URL
    
    init(pathToPhoto: URL) {
        self.pathToPhoto = pathToPhoto

        super.init()
    }
    
    required convenience init?(coder: NSCoder) {
        let photoName = coder.decodeObject(forKey: KeyPath.pathToPhoto.rawValue) as! String
        let pathToPhoto = MyFileManager.getSourcePath().appendingPathComponent(photoName)
        self.init(pathToPhoto: pathToPhoto)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(pathToPhoto.absoluteURL.lastPathComponent, forKey: KeyPath.pathToPhoto.rawValue)
    }
    
    static var supportsSecureCoding: Bool {
      return true
    }
    
    private enum KeyPath: String {
        case pathToPhoto
    }
    
}

