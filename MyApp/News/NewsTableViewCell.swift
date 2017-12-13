//
//  NewsTableViewCell.swift
//  MyApp
//
//  Created by Артем Чурсин on 08.12.2017.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    @IBOutlet weak var newsIcon: UIImageView!
    @IBOutlet weak var newlLabel: UILabel!
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var reposts: UILabel!
    @IBOutlet weak var comments: UILabel!
    @IBOutlet weak var views: UILabel!
    
    var flag: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension NewsTableViewCell: HaveImageView {
    
    func giveImageView() -> UIImageView {
        switch flag {
        case 0:
            flag = 1
            return newsIcon
        case 1:
            flag = 0
            return newsImage
        default:
            return newsImage
        }
    }
}
