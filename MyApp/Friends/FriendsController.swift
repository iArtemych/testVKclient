//
//  FriendsController.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RealmSwift

class FriendsController: UITableViewController {
    
    
    

//    let frservices = friendsServReq()
    var userfriends = [ServFriend]()

    let frservices = friendsServReq()
    var friends: Results<ServFriend>?
    var token: NotificationToken?
        let queue: OperationQueue = {
            let queue = OperationQueue()
            queue.qualityOfService = .userInteractive
            return queue
    }()
    
    
//    let friendService = FriendRequiests()
//    var friends: Results<Friend>?
//    var token: NotificationToken?
//    let queue: OperationQueue = {
//        let queue = OperationQueue()
//        queue.qualityOfService = .userInteractive
//        return queue
//----------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pairTableAndRealm()
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
    }

//----------------------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends?.count ?? 0
    }
//----------------------------------------------------------------------------------------
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsCell", for: indexPath) as! FriendsCell
//        let friend = userfriends[indexPath.row]
        let friend = friends![indexPath.row]
        let cashImage = GetCacheImage(url: friend.photoString)
        
        let setImageToRow = SetImageToRowInTabbleView(cell: cell, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(cashImage)
        queue.addOperation(cashImage)
        OperationQueue.main.addOperation(setImageToRow)
        
//        let url = URL(string: friend.photoString)!
        
//        cell.friendImage.af_setImage(withURL: url)
        cell.friendName.text = friend.name
        
//        print("массив фото \(indexPath.row) друга \(servFriend.photoStringArray)")
        
        return cell
    }
//----------------------------------------------------------------------------------------
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if  segue.identifier == "toFriendPhoto" {
            let destination = segue.destination as? FriendsPhotosController
            destination?.id = userfriends[(tableView.indexPathForSelectedRow?.row)!].ownID
        }
        

    }
 
//----------------------------------------------------------------------------------------

    func pairTableAndRealm(){
        guard let realm = try? Realm() else {print("проблема с реалмом в функции pairTableAndRealm");return}
        friends = realm.objects(ServFriend.self)
        token = friends?.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {print("проблема с реалмом в функции pairTableAndRealm");return}
            
            switch changes {
            case .initial:
                self?.frservices.vkfriend()
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .none)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .none)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }

}
