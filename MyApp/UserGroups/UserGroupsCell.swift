//
//  UserGroupsCell.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit

class UserGroupsCell: UITableViewCell {
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
