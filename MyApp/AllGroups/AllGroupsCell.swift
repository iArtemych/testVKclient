//
//  AllGroupsCell.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    @IBOutlet weak var allGroupImage: UIImageView!
    @IBOutlet weak var allGroupName: UILabel!
    @IBOutlet weak var allGroupMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
