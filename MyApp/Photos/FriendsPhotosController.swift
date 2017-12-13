//
//  FriendsPhotosController.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

private let reuseIdentifier = "Cell"

class FriendsPhotosController: UICollectionViewController{
    
    var id = 0
    
    var friendImCont = [String]()
    let friendService = friendsServReq()
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    var friendImageArr: [UIImage]? = nil
    var friendImageArrSTR: [String]? = nil
    
//----------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()

        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        friendService.photoRequest(id){ [weak self] photoArray in
            self?.friendImCont = photoArray
            self?.collectionView?.reloadData()
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//----------------------------------------------------------------------------------------
  

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//----------------------------------------------------------------------------------------

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friendImCont.count
//        if friendImageArrSTR != nil{
//            return friendImageArrSTR!.count
//        }else {return 1}
        
        //шаблон return 1
//        return 3
    }
//----------------------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPhotosCell", for: indexPath) as! FriendsPhotosCell
        
        let str = friendImCont[indexPath.row]
        let cashImage = GetCacheImage(url: str)
        let setImageToRowFriendPage = SetImageToRowInCollectionView(cell: cell, indexPath: indexPath, collectionView: collectionView)
        setImageToRowFriendPage.addDependency(cashImage)
        queue.addOperation(cashImage)
        OperationQueue.main.addOperation(setImageToRowFriendPage)
        
        
//        let url = URL(string: str)!
//        cell.icon.af_setImage(withURL: url)
    
        return cell
    }
//----------------------------------------------------------------------------------------


}
