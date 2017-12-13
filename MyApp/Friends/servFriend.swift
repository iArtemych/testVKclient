//
//  servFriend.swift
//  MyApp
//
//  Created by Артем Чурсин on 29.09.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class ServFriend:Object
{
    @objc dynamic var ownID: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    var name: String {
        return firstName + " " + lastName
    }
    @objc dynamic var photoString = ""
    
    override static func primaryKey() -> String? {
        return "ownerID"
    }

      convenience init(json: JSON) {
        
        self.init()
        
        self.ownID = json["id"].intValue
        self.firstName = json["first_name"].stringValue
        self.lastName = json["last_name"].stringValue
        self.photoString = json["photo_50"].stringValue
        
    }
    
}
