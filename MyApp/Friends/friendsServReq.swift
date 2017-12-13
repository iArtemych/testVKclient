//
//  friendsServReq.swift
//  MyApp
//
//  Created by Артем Чурсин on 06.10.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftKeychainWrapper
import RealmSwift

class friendsServReq
{
    private let baseUrl = "https://api.vk.com"
    private let version = "5.68"
    private let sessionManager:SessionManager = globalSessionManager
    private let token = KeychainWrapper.standard.string(forKey: "token")
    
    
    //----------------------------------------------------------------------------------------
    func vkfriend() {
        
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "access_token": self.token ?? print("error - nil"),
            "v": version,
            "fields":"nickname,domain,photo_50"
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData(queue: .global(qos: .userInteractive)) {
            repsons in
            guard let data = repsons.value else { return }
            

            do{
                let json = try JSON(data: data)
                let friend = json["response"]["items"].flatMap {ServFriend(json:$0.1) }
                //            print("я спарсил френда \(friend)")
                self.saveDataFriends(friend)
            }catch{
                print(error)
            }
            
            
        }
        
    }
    //----------------------------------------------------------------------------------------

    func saveDataFriends(_ friendArray: [ServFriend] )
    {
        do
        {
            let realm = try Realm()
            let oldFriends = realm.objects(ServFriend.self)
            print("путь к realm \(realm.configuration.fileURL)")
            try realm.write {
                realm.delete(oldFriends)
                realm.add(friendArray)
            }
        }catch{
            print("ошибка сохранения друзей в реалм \n \(error)")
        }
    }
    //----------------------------------------------------------------------------------------
    func loadDataFriends () -> [ServFriend]?  {
        do {
            let realm = try Realm()
            let friends = Array(realm.objects(ServFriend.self))
            return friends
        }catch {
            print("ошибка загрузки друзей из реалм \n \(error)")
            return nil
        }
    }
    
    
    //----------------------------------------------------------------------------------------
    func photoRequest(_ ownerID:Int, completion: @escaping ([String]) -> Void ) {
        let path = "/method/photos.getAll"
        let parameters: Parameters = [
            "owner_id": String(ownerID),
            "extended" : "0",
            "access_token": self.token ?? print("НОВАЯ ЕБАНАЯ ОШИБКА В ТОКЕНЕ"),
            "v": version
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }

            
            
            do{
                let json = try JSON(data: data)
                var uiArray = [String]()


                for (_,j) in json["response"]["items"]{
                    let photo = j["photo_130"].stringValue
                    //                print("принт путь фото внутри массива джосана\(photo)")
                    uiArray.append(photo)
                }


                completion(uiArray)
            }catch{
                print(error)
            }
            
            
            
//            let jsn = try? JSON(data: data)
//
//            guard let json = jsn else { return }
//            var uiArray = [String]()
//
//
//            for (_,j) in json["response"]["items"]{
//                let photo = j["photo_130"].stringValue
//
//                uiArray.append(photo)
//            }
//
//            completion(uiArray)
        }
    }
}
