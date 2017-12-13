//
//  NewsServReq.swift
//  MyApp
//
//  Created by Артем Чурсин on 08.12.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class NewsServReq
{
    private let version = "5.68"
    private let sessionManager:SessionManager = globalSessionManager
    private let token = KeychainWrapper.standard.string(forKey: "token")
    private let ownerId = KeychainWrapper.standard.string(forKey: "user_id")
    private let baseUrl = "https://api.vk.com"
    //----------------------------------------------------------------------------------------
    func newRequiest() {
        let myQueNewsRequiest = DispatchQueue(label: "myQueNewsRequiest", qos: .userInteractive, attributes: DispatchQueue.Attributes.concurrent)
        myQueNewsRequiest.async {
            
            
            let path = "/method/newsfeed.get"
            let parameters: Parameters = [
                "access_token": self.token ?? print("error - nil"),
                "v": self.version,
                "count": "20",
                "filters": "post"
                
            ]
            let url = self.baseUrl + path
            self.sessionManager.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) {
                repsons in
                guard let data = repsons.value else { return }
                let jsn = try? JSON(data: data)
                
                guard let json = jsn else { return }
                
                var news = [News()]
                for (_,j) in json["response"]["items"] {
                    if "post" == j["type"].stringValue{
                        var authName:String = ""
                        var authAvatar:String = ""
                        var authId = j["source_id"].intValue
                        if authId > 0 {
                            for (_,i) in json["response"]["profiles"]{
                                if i["id"].intValue == authId{
                                    authName = i["first_name"].stringValue + " " + i["last_name"].stringValue
                                    authAvatar = i["photo_50"].stringValue
                                }
                            }
                        }else if authId < 0 {
                            authId = abs(authId)
                            for (_,i) in json["response"]["groups"]{
                                if i["id"].intValue == authId{
                                    authName = i["name"].stringValue
                                    authAvatar = i["photo_50"].stringValue
                                }
                            }
                        }
                        news.append(News(json: j, authName: authName, authAvatar: authAvatar))
                    }
                    
                }
                
                self.saveNewsData(news)
                
                
            }
            
        }
    }
    //----------------------------------------------------------------------------------------
    func saveNewsData (_ newsArray: [News]) {
        do {
            let realm = try Realm()
            let oldNews = realm.objects(News.self)
            
            try realm.write {
                realm.delete(oldNews)
                realm.add(newsArray)
            }
        }catch{
            print("ошибка сохранения новостей в реалм \n \(error)")
        }
    }
    func postNewRequiest(text: String){
        let userDefaults = UserDefaults.standard
        let lat = userDefaults.double(forKey: "GEOlat")
        let long = userDefaults.double(forKey: "GEOlong")
        let path = "/method/wall.post"
        print("айди \(ownerId)")
        let parameters: Parameters = [
            "access_token": self.token ?? print("error - nil"),
            "owner_id" : self.ownerId ?? print("error - nil"),
            "message" : text,
            "lat": String(lat),
            "long": String(long),
            "v": self.version
        ]
        let url = self.baseUrl + path
        self.sessionManager.request(url, method: .post, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) {
            repsons in
            guard let data = repsons.value else { return }
            let jsn = try? JSON(data: data)
            
            guard let json = jsn else { return }
            print("получилось")
            print(json)
            userDefaults.removeObject(forKey: "GEOlat")
            userDefaults.removeObject(forKey: "GEOlong")
            userDefaults.removeObject(forKey: "GeoPosition")
            userDefaults.removeObject(forKey: "allGeoPosition")
            
        }
    }
}
