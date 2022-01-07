//
//  URL+Extension.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

extension URL {
    
    var fragmentDictionary: [String: String] {
        return dictionaryFromFormEncodedString(fragment)
    }
    
    var queryDictionary: [String: String] {
        return dictionaryFromFormEncodedString(query)
    }
    
    var fragmentAndQueryDictionary: [String: String] {
        var result = fragmentDictionary
        queryDictionary.forEach { (key, value) in
            result[key] = value
        }
        return result
    }
    
    func dictionaryFromFormEncodedString(_ input: String?) -> [String: String] {
        var result = [String: String]()
        
        guard let input = input else {
            return result
        }
        let inputPairs = input.components(separatedBy: "&")
        
        for pair in inputPairs {
            let split = pair.components(separatedBy: "=")
            if split.count == 2 {
                if let key = split[0].removingPercentEncoding, let value = split[1].removingPercentEncoding {
                    result[key] = value
                }
            }
        }
        return result
    }
}
