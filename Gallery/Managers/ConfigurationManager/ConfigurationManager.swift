//
//  ConfigurationManager.swift
//  Gallery
//
//  Created by echo on 3/30/21.
//

import Foundation

class ConfigurationManager {
    
    static let shared = ConfigurationManager()
    
    var templateFormat: String?
    
    init() {
        let configuration: [String: Any]?
        if let configurationPlistPath = Bundle.main.url(forResource: "configuration", withExtension: "plist") {
            do {
                let configurationPlistData = try Data(contentsOf: configurationPlistPath)
                configuration = try (PropertyListSerialization.propertyList(
                    from: configurationPlistData,
                    options: [],
                    format: nil
                ) as? [String : Any])
                templateFormat = configuration?[KeyPath.template.rawValue] as? String
            } catch {
                print("\(error.localizedDescription)")
            }
        }
    }
    
}

extension ConfigurationManager {
    
    private enum KeyPath: String {
        case template
    }
}
