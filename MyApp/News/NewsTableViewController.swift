//
//  NewsTableViewController.swift
//  MyApp
//
//  Created by Артем Чурсин on 08.12.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire
import AlamofireImage

class NewsTableViewController: UITableViewController {

    
    let newsService = NewsServReq()
    var news: Results<News>?
    var token: NotificationToken?
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    //----------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders


    }
//----------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news?.count ?? 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        let new = news![indexPath.row]
        
        if new.photoString != "" {
            let url = URL(string: new.photoString)
            if let u = url {
                cell.newsImage.af_setImage(withURL: u)
                
            }else {
                cell.newsImage.image = nil
            }
        }
        
//----------------------------------------------------------------------------------------
        
        if new.authAvatar != "" {
            let url2 = URL(string: new.authAvatar)
            if let u = url2 {
                cell.newsIcon.af_setImage(withURL: u)
                
            }else {
                cell.newsIcon.image = nil
            }
        }
        
        
        cell.newlLabel.text = new.authName
        cell.comments.text = "C " + String(new.comments)
        cell.likes.text = "L " + String(new.likes)
        cell.reposts.text = "R " + String(new.reposts)
        cell.views.text = "C " + String(new.views)
        
        cell.newsText.text = new.text
        
        return cell
    }
    func pairTableAndRealm(){
        guard let realm = try? Realm() else {print("проблема с реалмом в функции pairTableAndRealm");return}
        news = realm.objects(News.self)
        token = news?.observe{ [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {print("проблема с реалмом в функции pairTableAndRealm");return}
            
            switch changes {
            case .initial:
                self?.newsService.newRequiest()
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
