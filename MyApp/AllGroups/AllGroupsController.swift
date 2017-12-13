//
//  AllGroupsController.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class AllGroupsController: UITableViewController {
    
//---------------------------------------------------------------------------------
  var allGroups = [Groups]()
//---------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

  
    }
//---------------------------------------------------------------------------------

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//---------------------------------------------------------------------------------

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//---------------------------------------------------------------------------------

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allGroups.count
    }
//---------------------------------------------------------------------------------

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell

        
        
        let ser: Groups

        ser = allGroups[indexPath.row]

        let url = URL(string: ser.photoString)!
        cell.allGroupName.text = ser.name
        cell.allGroupImage.af_setImage(withURL: url)
        cell.allGroupMembers.text = String(ser.membersCount)

        
//        cell.allGroupName.text = groups[indexPath.row].0
//        cell.allGroupMembers.text = String(groups[indexPath.row].1)

        return cell
    }
//---------------------------------------------------------------------------------



}
