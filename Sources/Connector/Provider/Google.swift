//
//  Google.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public class Google: OAuth2 {
    
    public init() {
        guard let urlScheme = LibOfficer.registeredURLSchemes(filter: {$0.hasPrefix("com.googleusercontent.apps.")}).first else {
            preconditionFailure("You must configure your Google URL Scheme to use Google login.")
        }
        
        let appId = urlScheme.components(separatedBy: ".").reversed().joined(separator: ".")
        let authorizationEndpoint = URL(string: "https://accounts.google.com/o/oauth2/auth")!
        let redirectionEndpoint = URL(string: "\(urlScheme):/oauth2callback")!
        
        super.init(clientId: appId, authorizationEndpoint: authorizationEndpoint, redirectEndpoint: redirectionEndpoint, grantType: .authorizationCode)
        self.scopes = ["email", "profile"]
    }
    
    public override func externalHandler(_ url: URL, callback: @escaping ExternalLoginCallback) {
        guard let authorizationCode = url.queryDictionary["code"], url.queryDictionary["state"] == state else {
            if let error = OAuth2Error.error(url.queryDictionary) ?? OAuth2Error.error(url.queryDictionary) {
                callback(nil, error)
            } else {
                callback(nil, ConnectorError.InternalSDKError)
            }
            return
        }
        exchangeCodeForAccessToken(authorizationCode, callback: callback)
    }
    
    private func exchangeCodeForAccessToken(_ authorizationCode: String, callback: @escaping ExternalLoginCallback) {
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        let url = URL(string: "https://www.googleapis.com/oauth2/v4/token")!
        
        let requestParams: [String: String?] = [
            "client_id": clientId,
            "code": authorizationCode,
            "grant_type": "authorization_code",
            "redirect_uri": authorizationURLParameters["redirect_uri"] ?? nil
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = LibOfficer.queryString(requestParams)?.data(using: .utf8)
        
        let task = session.dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data, let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any], let accessToken = json["access_token"] as? String else {
                callback(nil, ConnectorError.InternalSDKError)
                return
            }
            callback(accessToken, nil)
        }
        task.resume()
    }
}
