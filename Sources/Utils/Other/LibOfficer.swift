//
//  LibOfficer.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

class LibOfficer {
    
    static func registeredURLSchemes(filter closure: (String) -> Bool) -> [String] {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]] else {
            return [String]()
        }
        
        // Convert the complex dictionary into an array of URL schemes
        let urlSchemes: [String] = urlTypes.reduce(into: []) { (result, component) in
            if let schemes = component["CFBundleURLSchemes"] as? [String] {
                result.append(contentsOf: schemes)
            }
        }
        
        return urlSchemes.compactMap({closure($0) ? $0 : nil})
    }
    
    static func queryString(_ parts: [String: String?]) -> String? {
        return parts.compactMap { key, value -> String? in
            if let value = value {
                return key + "=" + value
            } else {
                return nil
            }
        }.joined(separator: "&").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
}
