//
//  UIImage.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

extension UIImage {
    
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == .up) {
          return self;
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)

        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return normalizedImage;
    }
    
}
