//
//  ConnectorProtocol.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public protocol ConnectorProtocol {
    var urlScheme: String { get }
    var authURL: URL { get }
    func externalHandler(_ url: URL, callback: @escaping ExternalLoginCallback)
}

public extension ConnectorProtocol {
    func login(_ callback: @escaping ExternalLoginCallback) {
        Connector.login(self, callback: callback)
    }
}

