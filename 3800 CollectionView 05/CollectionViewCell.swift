//
//  CollectionViewCell.swift
//  3800 CollectionView 05
//
//  Created by Trương Quang on 7/18/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var outletImage: UIImageView!
    @IBOutlet weak var outletChecked: UIVisualEffectView!
    
    var isEditing = false {
        didSet {
            outletChecked.isHidden = true
        }
    }
    
    override var isSelected: Bool{
        didSet{
            if isEditing {
                outletChecked.isHidden = isSelected ? false : true
            }
        }
    }
    
}
