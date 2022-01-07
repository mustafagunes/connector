//
//  OAuth2.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public enum OAuth2GrantType: String {
    case authorizationCode = "code"
    case implicit = "token"
    case custom = ""
}

public class OAuth2: ConnectorProtocol {
    
    public final let clientId: String
    public final let redirectEndpoint: URL
    public final var scopes = Set<String>()
    public final let grantType: OAuth2GrantType
    public final let authorizationEndpoint: URL
    public final let state = String(arc4random_uniform(10000000))
    
    public final var urlScheme: String {
        return redirectEndpoint.scheme!
    }
    
    public var authorizationURLParameters: [String: String?] {
        guard grantType != .custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        return [
            "client_id": clientId,
            "redirect_uri": redirectEndpoint.absoluteString,
            "response_type": grantType.rawValue,
            "scope": scopes.joined(separator: " "),
            "state": state
        ]
    }
    
    public var authURL: URL {
        guard grantType != .custom else {
            preconditionFailure("Custom Grant Type Not Supported")
        }
        
        var url = URLComponents(url: authorizationEndpoint, resolvingAgainstBaseURL: false)!
        
        url.queryItems = authorizationURLParameters.compactMap({key, value -> URLQueryItem? in
            return value != nil ? URLQueryItem(name: key, value: value) : nil
        })
        
        return url.url!
    }
    
    public func externalHandler(_ url: URL, callback: @escaping ExternalLoginCallback) {
        switch grantType {
        case .authorizationCode:
            preconditionFailure("Authorization Code Grant Type Not Supported")
        case .implicit:
            // Get the access token, and check that the state is the same
            guard let accessToken = url.fragmentDictionary["access_token"], url.fragmentAndQueryDictionary["state"] == state else {
                /**
                 Facebook's mobile implicit grant type returns errors as
                 query. Don't think it's a huge issue to be liberal in looking
                 for errors, so will check both.
                 */
                if let error = OAuth2Error.error(url.fragmentAndQueryDictionary) {
                    callback(nil, error)
                } else {
                    callback(nil, ConnectorError.InternalSDKError)
                }
                return
            }
            
            callback(accessToken, nil)
        case .custom:
            preconditionFailure("Custom Grant Type Not Supported")
        }
    }
    
    public init(clientId: String, authorizationEndpoint: URL, redirectEndpoint: URL, grantType: OAuth2GrantType) {
        self.grantType = grantType
        self.clientId = clientId
        self.authorizationEndpoint = authorizationEndpoint
        self.redirectEndpoint = redirectEndpoint
        
        if LibOfficer.registeredURLSchemes(filter: {$0 == self.urlScheme}).count != 1 {
            preconditionFailure("You must register your URL Scheme in Info.plist.")
        }
    }
}
