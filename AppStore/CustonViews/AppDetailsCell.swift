//
//  AppDetailsCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/22/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class AppDetailsCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var AboutLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var whatNewLabel: UILabel!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var releaseNoteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    var app:Result!{
        didSet{
            nameLabel.text = app?.trackName
            releaseNoteLabel.text = app?.releaseNotes
            AboutLabel.text = app?.primaryGenreName
            sellerName.text = app?.sellerName
            imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            priceButton.setTitle(app?.formattedPrice, for: .normal)
            
        }
    }
   
}





