//
//  MyFileManager.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import UIKit

class MyFileManager {
    
    static let rootPath: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        let destinationPath = paths.first!.appendingPathComponent(Defaults.rootFolderName)
        var isFolder: ObjCBool = false
        let isFileExists = FileManager.default.fileExists(atPath: destinationPath.absoluteString, isDirectory: &isFolder)
        if !isFileExists {
            do {
                try FileManager.default.createDirectory(at: destinationPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create a root folder")
            }
        }
        return destinationPath
    }()
    
    class func loadData() -> [Category] {
        let dataFile = MyFileManager.getFilePath()
        print(rootPath.absoluteURL)
        var categories: [Category] = []
        do {
            let codedData = try Data(contentsOf: dataFile)
            categories = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(codedData) as! [Category]
        } catch {
            print("Couldn't load Data")
        }
        
        return categories
    }
    
    class func saveData(categories: [Category]) {
        let dataFile = MyFileManager.getFilePath()
        
        do {
            let codedData = try NSKeyedArchiver.archivedData(withRootObject: categories, requiringSecureCoding: true)
            try codedData.write(to: dataFile)
        } catch {
            print("Couldn't save a file. \(error.localizedDescription)")
        }
    }
    
    class func saveImage(image: UIImage) -> URL {
        let id = UUID().uuidString
        let pngDate = image.pngData()
        
        var sourcePath = getSourcePath()
        
        var isFolder: ObjCBool = false
        let isFileExist = FileManager.default.fileExists(atPath: sourcePath.absoluteString, isDirectory: &isFolder)
        if !isFileExist {
            do {
                try FileManager.default.createDirectory(at: sourcePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create a root folder")
            }
        }
        sourcePath.appendPathComponent(id)
        sourcePath.appendPathExtension("png")
        do {
            try pngDate?.write(to: sourcePath, options: .atomic)
        } catch {
            print("Couldn't save the file")
        }
        
        return sourcePath
    }
    
    class func loadImage(by url: URL, completionBlock: @escaping (UIImage) -> ()) {
        let concurrentQueue = DispatchQueue(label: "net.company.Gallery", attributes: .concurrent)
        concurrentQueue.async {
            guard let dataOfImage = try? Data(contentsOf: url) else {
                return
            }
            guard let image = UIImage(data: dataOfImage) else {
                return
            }
            DispatchQueue.main.async {
                completionBlock(image)
            }
        }
    }
    
    class func removeImage(by url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    private class func getFilePath() -> URL {
        var dataFile = MyFileManager.rootPath
        dataFile.appendPathComponent(Defaults.dataFile)
        
        return dataFile
    }
    
    class func getSourcePath() -> URL {
        var sourcePath = MyFileManager.rootPath
        sourcePath.appendPathComponent(Defaults.sourceFolderName)
        
        return sourcePath
    }
    
    private enum Defaults {
        static let rootFolderName = "Privacy"
        static let sourceFolderName = "Source"
        static let dataFile = "Data.plist"
    }
    
}
