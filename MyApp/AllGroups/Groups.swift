//
//  Groups.swift
//  MyApp
//
//  Created by Артем Чурсин on 06.10.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import SwiftyJSON

class Groups{
    
    var ownerID: Int = 0
    var name: String = ""
    var photoString = ""
    
    var membersCount: Int = 0
    
    init(json: JSON){
        //        self.init()
        self.ownerID = json["id"].intValue
        
        self.name = json["name"].stringValue
        self.membersCount = json["members_count"].intValue
        self.photoString = json["photo_50"].stringValue
    }
    
}
