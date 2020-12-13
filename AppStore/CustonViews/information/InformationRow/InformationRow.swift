//
//  InformationRow.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/24/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import SafariServices
class InformationRow: UICollectionViewCell {

    @IBOutlet weak var seller: UILabel!
    @IBOutlet weak var sizeApp: UILabel!
    @IBOutlet weak var Category: UILabel!
    @IBOutlet weak var ageRating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var developerButton: UIButton!
    @IBOutlet weak var Copyright: UILabel!
    @IBOutlet weak var Price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var app :Result?{
        didSet{
            seller.text      = app?.sellerName
            sizeApp.text     = "\(String(app?.fileSizeBytes.prefix(3) ?? "")) MB"
            Category.text    = app?.primaryGenreName
            ageRating.text   = app?.contentAdvisoryRating
            releaseDate.text = String(app?.releaseDate.prefix(10) ?? "")
            Price.text       = app?.formattedPrice
            Copyright.text   = "© \(app?.sellerName ?? "" )"
        }
    }
    @IBAction func developerWebsiteBtt(_ sender: Any) {
       guard  let url = URL(string: app?.sellerUrl ?? "") else{return}
          presntSafariVC( with: url )
    }
    
    func presntSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url )
        self.window?.rootViewController?.present(safariVC, animated: true)

    }

}


