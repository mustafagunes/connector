//
//  Connector.swift
//  
//
//  Created by Mustafa Gunes on 7.01.2022.
//

import UIKit
import SafariServices

public typealias ExternalLoginCallback = (String?, NSError?) -> Void

public final class Connector {
    private static var currentLoginProvider: ConnectorProtocol?
    private static var callback: ExternalLoginCallback?
    private static var safari: UIViewController?
    
    public static func login(_ loginProvider: ConnectorProtocol, callback: @escaping ExternalLoginCallback) {
        self.currentLoginProvider = loginProvider
        self.callback = callback
        
        presentSafariView(loginProvider.authURL)
    }
    
    /// Deep link handler (iOS9)
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        safari?.dismiss(animated: true, completion: nil)
        guard let callback = callback, url.scheme == currentLoginProvider?.urlScheme else {
            return false
        }
        currentLoginProvider?.externalHandler(url, callback: callback)
        currentLoginProvider = nil
        
        return true
    }
    
    /// Deep link handler (<iOS9)
    public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return self.application(application, open: url, options: [UIApplication.OpenURLOptionsKey: Any]())
    }
    
    private static func presentSafariView(_ url: URL) {
        if #available(iOS 9, *) {
            safari = SFSafariViewController(url: url)
            var topController = UIApplication.shared.keyWindow?.rootViewController
            while let vc = topController?.presentedViewController {
                topController = vc
            }
            topController?.present(safari!, animated: true, completion: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
