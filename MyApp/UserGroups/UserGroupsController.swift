//
//  UserGroupsController.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class UserGroupsController: UITableViewController {
    
    var groupService = GroupsServReq()
    var userGroups = [Groups]()
 //---------------------------------------------------------------------------------

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        groupService.groupRequest(){[weak self] groups in
            self?.userGroups = groups
            self?.tableView?.reloadData()
            
        }
        
    }
//---------------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
//---------------------------------------------------------------------------------
   

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
//---------------------------------------------------------------------------------

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userGroups.count
    }

//---------------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserGroupsCell", for: indexPath) as! UserGroupsCell

        let group = userGroups[indexPath.row]
        let url = URL(string: group.photoString)!
        
        cell.groupImage.af_setImage(withURL: url)
        cell.groupName.text = group.name

        return cell
    }
    //---------------------------------------------------------------------------------
    @IBAction func addGroup(segue: UIStoryboardSegue)
    {
 
        //Проверяем идентификатор перехода, что бы убедится что это нужныий переход
        if segue.identifier == "addGroup" {
            //получаем ссылку на контроллер с которого осуществлен переход
            let AllGroupsController = segue.source as! AllGroupsController
            //получаем индекс выделенной ячейки
            if let indexPath = AllGroupsController.tableView.indexPathForSelectedRow {
                //получаем город по индксу
                groupService.groupJoin(String(userGroups[indexPath.row].ownerID))
                tableView.reloadData()
                }
            }
            
        }
    //---------------------------------------------------------------------------------

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupService.groupLeave(String(userGroups[indexPath.row].ownerID))
            
        }
    }
}
    



