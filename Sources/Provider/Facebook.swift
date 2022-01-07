//
//  Facebook.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public enum FacebookAuthType: String {
    case reRequest = "rerequest"
    case reAuthenticate = "reauthenticate"
    case none = ""
}

public class Facebook: OAuth2 {
    
    public var authType: FacebookAuthType = .none
    
    override public var authorizationURLParameters: [String : String?] {
        var result = super.authorizationURLParameters
        result["auth_type"] = authType.rawValue
        return result
    }
    public init() {
        guard let urlScheme = LibOfficer.registeredURLSchemes(filter: {$0.hasPrefix("fb")}).first,
            let range = urlScheme.range(of: "\\d+", options: .regularExpression) else {
                preconditionFailure("You must configure your Facebook URL Scheme to use Facebook login.")
        }
        let clientId = String(urlScheme[range.lowerBound..<range.upperBound])
        let authorizationEndpoint = URL(string: "https://www.facebook.com/dialog/oauth")!
        let redirectEndpoint = URL(string: urlScheme + "://authorize")!
        
        super.init(clientId: clientId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectEndpoint, grantType: .implicit)
    }
}
