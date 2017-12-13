//
//  FriendsCell.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension FriendsCell: HaveImageView {
    
    func giveImageView() -> UIImageView {
        return friendImage
    }
}
