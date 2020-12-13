//
//  SearchResultCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/18/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet weak var appIconIamgeView: UIImageView!
    @IBOutlet weak var screenShot1IamgeView: UIImageView!
    @IBOutlet weak var screenShot2IamgeView: UIImageView!
    @IBOutlet weak var screenShot3IamgeView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var getButton: UIButton!
    
    var appResults :Result!{
        didSet{
            nameLabel?.text = appResults.trackName
            categoryLabel?.text = appResults.primaryGenreName
            ratingLabel?.text = "\(appResults.averageUserRating ?? 0)"
            let url1 = URL(string: appResults.artworkUrl100)
            
           appIconIamgeView.sd_setImage(with: url1)
           screenShot1IamgeView.sd_setImage(with: URL(string:appResults.screenshotUrls[0]))
            if appResults.screenshotUrls.count > 1 {
               screenShot2IamgeView.sd_setImage(with: URL(string:appResults.screenshotUrls[1]))
            }
            if appResults.screenshotUrls.count > 2 {
               screenShot3IamgeView.sd_setImage(with: URL(string:appResults.screenshotUrls[2]))
            }
        }
    }
    
}
