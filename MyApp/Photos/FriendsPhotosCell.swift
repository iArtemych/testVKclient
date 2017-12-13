//
//  FriendsPhotosCell.swift
//  MyApp
//
//  Created by Артем Чурсин on 22.09.17.
//  Copyright © 2017 Artem. All rights reserved.
//

import UIKit

class FriendsPhotosCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
}
extension FriendsPhotosCell: HaveImageView {
    
    func giveImageView() -> UIImageView {
        return icon
    }
}
