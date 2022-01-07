//
//  ConnectorError.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public class ConnectorError: NSError {
    
    public static let InternalSDKError = ConnectorError(code: 0, description: "Internal SDK Error")
    
    public init(code: Int, description: String) {
        var userInfo = [String: Any]()
        userInfo[NSLocalizedDescriptionKey] = description
        
        super.init(domain: "Connector", code: code, userInfo: userInfo)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
