//
//  ReviewCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/23/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import Cosmos
class ReviewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
  //  @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var bodyLabel: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        ratingView.settings.updateOnTouch = false
    }

}
