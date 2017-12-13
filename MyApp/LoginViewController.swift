//
//  LoginViewController.swift
//  MyApp
//
//  Created by Артем Чурсин on 15.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
//-----------------------------------------------------------------

//var token : String = ""
//-----------------------------------------------------------------

class LoginViewController: UIViewController {
    
    let vkservices = vkService()
    
    

    @IBOutlet weak var webview: WKWebView!{
        didSet{
            
            webview.navigationDelegate = self
        }
    }
    
    
//-----------------------------------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.load(vkservices.authVk())
        
        }
}
//---------------------------------------------------------------------------------

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        print("huy osla")
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        if let token = params["access_token"]
        {
            KeychainWrapper.standard.set(token, forKey: "token")
        }
        
        if let user_id = Int(params["user_id"]!)
        {
            KeychainWrapper.standard.set(user_id, forKey: "user_id")
        }
        
//        if loginToken != nil
//        {
//        token = loginToken!
//        }
//        print(token)
        
        decisionHandler(.cancel)
        performSegue(withIdentifier: "autoLogin", sender: true)
        
    }
}
