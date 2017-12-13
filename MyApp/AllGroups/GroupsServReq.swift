//
//  GroupsServReq.swift
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


class GroupsServReq
{
    private let baseUrl = "https://api.vk.com"
    private let version = "5.68"
    private let sessionManager:SessionManager = globalSessionManager
    private let token = KeychainWrapper.standard.string(forKey: "token")
//---------------------------------------------------------------------------------
    
    func groupRequest(completion: @escaping ([Groups]) -> Void ) {
        let path = "/method/groups.get"
        let parameters: Parameters = [
            "extended" : "1",
            "access_token": self.token ?? print("error - nil"),
            "v": version,
            "fields": "members_count"
            
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }
//            let json = JSON(data: data)
            let jsn = try? JSON(data: data)
            //            let json : JSON
            //            do {
            //                json = try JSON(data: data)
            //            } catch {
            //                print(error)
            //            }
            guard let json = jsn else { return }
            //            print("принт реквеста группы \(repsons.request)")
            let group = json["response"]["items"].flatMap {Groups(json:$0.1) }
            //            print("я спарсил группу \(group)")
            completion(group)
            //            print("\nпринт из group request \(repsons.request)\n")
            //            print(repsons.value ?? repsons.error ?? "error fuck")
            
        }
    }
//---------------------------------------------------------------------------------
    func groupSearchRequest(_ q:String,  completion: @escaping ([Groups]) -> Void) {
        var groupIds = ""
        var path = "/method/groups.search"
        var parameters: Parameters = [
            "q": q,
            "access_token": self.token ?? print("error - nil"),
            "count": "25",
            "v": version
        ]
        var url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }
//            let json = JSON(data: data)
            let jsn = try? JSON(data: data)
            //            let json : JSON
            //            do {
            //                json = try JSON(data: data)
            //            } catch {
            //                print(error)
            //            }
            guard let json = jsn else { return }
            let count = json["response"]["items"].count - 1
            print("я каунт из джсона\(count)")
            for i in 0...count{
                let id = json["response"]["items"][i]["id"].stringValue
                print("/n это принт идшика в серче \(id)")
                if i == 0{
                    groupIds = id
                }else {
                    groupIds = groupIds + "," + id
                }
                
            }
            parameters.removeAll()
            path = "/method/groups.getById"
            parameters = [ "access_token" : self.token ?? print("error - nil"),
                           "group_ids" : groupIds,
                           "fields"    : "members_count",
                           "version"   : self.version]
            url = self.baseUrl + path
            Alamofire.request(url, method: .get, parameters: parameters).responseData {repsons in
                guard let data = repsons.value else { return }
//                let json = JSON(data: data)
                let jsn = try? JSON(data: data)
                //            let json : JSON
                //            do {
                //                json = try JSON(data: data)
                //            } catch {
                //                print(error)
                //            }
                guard let json = jsn else { return }
                let group = json["response"].flatMap {Groups(json:$0.1) }
                print(json["response"])
                completion(group)
            }
            
            //            group = json["response"]["items"].flatMap {Group(json2:$0.1) }
            ////            print("я спарсил группу \(group)")
            //            completion(group)
            //            print("\nпринт из group request \(repsons.request)\n")
            //            print(repsons.value ?? repsons.error ?? "error fuck")
            
        }
    }
//---------------------------------------------------------------------------------
    func groupCountMebmerRequiest(_ groupId:String,  completion: @escaping (Int) -> Void) {
        
        let path = "/method/groups.getById"
        let parameters: Parameters = [
            "group_id": groupId,
            "fields": "members_count",
            "v": version
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }
//            let json = JSON(data: data)
            let jsn = try? JSON(data: data)
            //            let json : JSON
            //            do {
            //                json = try JSON(data: data)
            //            } catch {
            //                print(error)
            //            }
            guard let json = jsn else { return }
            
            let count = json["response"]["members_count"].intValue
            print("принт из возврата каунта группы \(count)")
            completion(count)
            //            print("\nпринт из group request \(repsons.request)\n")
            //            print(repsons.value ?? repsons.error ?? "error fuck")
            
        }
    }
//---------------------------------------------------------------------------------
    func groupJoin(_ groupId:String) {
        
        let path = "/method/groups.join"
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": self.token ?? print("error - nil"),
            "v": version
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }
//            let json = JSON(data: data)
            let jsn = try? JSON(data: data)
            //            let json : JSON
            //            do {
            //                json = try JSON(data: data)
            //            } catch {
            //                print(error)
            //            }
            guard let json = jsn else { return }
            let f = 1
            if f == json["response"].intValue {
                print("присоединился")
            }else{print("не присоединился \(json["response"].intValue)")}
            //            print("\nпринт из group request \(repsons.request)\n")
            //            print(repsons.value ?? repsons.error ?? "error fuck")
            
        }
    }
//---------------------------------------------------------------------------------
    func groupLeave(_ groupId:String) {
        
        let path = "/method/groups.leave"
        let parameters: Parameters = [
            "group_id": groupId,
            "access_token": self.token ?? print("error - nil"),
            "v": version
        ]
        let url = baseUrl + path
        sessionManager.request(url, method: .get, parameters: parameters).responseData {
            repsons in
            guard let data = repsons.value else { return }
//            let json = JSON(data: data)
            let jsn = try? JSON(data: data)
            //            let json : JSON
            //            do {
            //                json = try JSON(data: data)
            //            } catch {
            //                print(error)
            //            }
            guard let json = jsn else { return }
            
            let f = 1
            if f == json["response"].intValue {
                print("удалил к херам")
            }else{print("не удалил \(json["response"].intValue)")}
            //            print("\nпринт из group request \(repsons.request)\n")
            //            print(repsons.value ?? repsons.error ?? "error fuck")
            
        }
    }
    
    
    
}
