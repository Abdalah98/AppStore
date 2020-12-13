//
//  AppsGroubCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/20/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class AppsGroubCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var AppGroupcollectionView: UICollectionView!

    let topBottomPadding:CGFloat = 12
    let lineSpacing:CGFloat = 10
    var appGroub:AppGroup?
    var didSelectHeader:((FeedResult)->())?
    

}

