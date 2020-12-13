//
//  ReviewRowCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/23/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import Cosmos
class ReviewRowCell: UICollectionViewCell {
    
    @IBOutlet weak var ReviewRowController: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ReviewRowController.dataSource = self
        ReviewRowController.delegate = self
        configureCollection()
        snapHorizontal()

    }
    var reviews:Reviews?{
        didSet{
            self.ReviewRowController.reloadData()
        }
    }
    
}
    extension ReviewRowCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        
        
        fileprivate func configureCollection(){
            ReviewRowController.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
            let nib = UINib(nibName: Constant.ReviewCell, bundle: nil)
            ReviewRowController.register(nib, forCellWithReuseIdentifier: Constant.Review)
            
        }
        
        fileprivate func snapHorizontal(){
            ReviewRowController.decelerationRate = .fast
            let layout = BetterSnappingLayout()
            layout.scrollDirection = .horizontal
            ReviewRowController.collectionViewLayout = layout
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return reviews?.feed.entry.count ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Review, for: indexPath) as! ReviewCell
            let entry               = reviews?.feed.entry[indexPath.item]
            cell.titleLabel.text    = entry?.title.label
            cell.authorLabel.text   = entry?.author.name.label
            cell.bodyLabel.text     = entry?.content.label
            cell.ratingView.rating  = Double(entry!.rating.label)!
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(width: frame.width - 48, height: 236)
}

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
              return 16
          }
}
