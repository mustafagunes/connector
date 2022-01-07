//
//  File.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import Foundation

public class OAuth2Error: ConnectorError {
    
    public static let mapping: [String: OAuth2ErrorCode] = [
        "invalid_request": .invalidRequest,
        "unauthorized_client": .unauthorizedClient,
        "access_denied": .accessDenied,
        "unsupported_response_type": .unsupportedResponseType,
        "invalid_scope": .invalidScope,
        "server_error": .serverError,
        "temporarily_unavailable": .temporarilyUnavailable
    ]
    
    public class func error(_ callbackParameters: [String: String]) -> ConnectorError? {
        let errorCode = mapping[callbackParameters["error"] ?? ""]
        if let errorCode = errorCode {
            let errorDescription = callbackParameters["error_description"]?
                .removingPercentEncoding?
                .replacingOccurrences(of: "+", with: " ") ?? errorCode.description
            return OAuth2Error(code: errorCode.rawValue, description: errorDescription)
        } else {
            return nil
        }
    }
}

public enum OAuth2ErrorCode: Int, CustomStringConvertible {
    case invalidRequest = 100
    case unauthorizedClient
    case accessDenied
    case unsupportedResponseType
    case invalidScope
    case serverError
    case temporarilyUnavailable
    
    public var description: String {
        switch self {
        case .invalidRequest:
            return "The OAuth request is missing a required parameter"
        case .unauthorizedClient:
            return "The client ID is not authorized to make this request"
        case .accessDenied:
            return "You denied the login request"
        case .unsupportedResponseType:
            return "The grant type requested is not supported"
        case .invalidScope:
            return "A scope requested is invalid"
        case .serverError:
            return "The login server experienced an internal error"
        case .temporarilyUnavailable:
            return "The login server is temporarily unavailable. Please try again later. "
        }
    }
}
