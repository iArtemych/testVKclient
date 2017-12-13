//
//  VKServices.swift
//  MyApp
//
//  Created by Артем Чурсин on 26.09.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftKeychainWrapper

let configuration = URLSessionConfiguration.default
let globalSessionManager = SessionManager(configuration: configuration)

class vkService
{
    let sessionManager:SessionManager = globalSessionManager
    private let token = KeychainWrapper.standard.string(forKey: "token")
    let baseUrl = "https://api.vk.com"
    private let cliend_id = "6198016"
    private let path = "/method"
    private let versionAPI = "5.68"
    
//----------------------------------------------------------------------------------------
    func authVk() -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: cliend_id),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: versionAPI)
        ]
        let request = URLRequest(url: urlComponents.url!)
        return request
    }
//----------------------------------------------------------------------------------------
    

    

    
}

