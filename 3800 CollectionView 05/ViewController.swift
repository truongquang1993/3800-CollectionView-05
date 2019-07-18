//
//  ViewController.swift
//  3800 CollectionView 05
//
//  Created by Trương Quang on 7/18/19.
//  Copyright © 2019 truongquang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outletImage: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let evalueImage = self.image {
            outletImage.image = evalueImage
        }
    }
    
    
}

