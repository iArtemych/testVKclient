//
//  News.swift
//  MyApp
//
//  Created by Артем Чурсин on 08.12.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class News:Object{
    
    @objc  dynamic var idNews: String = ""
    @objc  dynamic var text: String = ""
    @objc  dynamic var photoString = ""
    @objc  dynamic var comments = 0
    @objc  dynamic var likes = 0
    @objc  dynamic var reposts = 0
    @objc  dynamic var views = 0
    @objc  dynamic var authId = 0
    @objc  dynamic var authName = ""
    @objc  dynamic var authAvatar = ""
    
    
    convenience init(json: JSON, authName: String, authAvatar: String){
        self.init()
        
        self.idNews = json["date"].stringValue + json["post_id"].stringValue
        self.text = json["text"].stringValue
        for (_,j) in json["attachments"]{
            if j["type"].stringValue == "photo"{
                self.photoString = j["photo"]["photo_130"].stringValue
            }
        }
        self.comments = json["comments"]["count"].intValue
        self.likes = json["likes"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        self.authId = json["source_id"].intValue
        self.authName = authName
        self.authAvatar = authAvatar
        
        
    }
    
}
