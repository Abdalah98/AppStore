//
//  appHeaderHorizontalController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/20/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import SDWebImage

extension AppsPageHeaderReusableView: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    override func awakeFromNib() {
        super.awakeFromNib()
        CollectionView.decelerationRate = .fast
        
        CollectionView.dataSource = self
        CollectionView.delegate = self
        configureCollection()
        snapHorizontal()
    }
    
    // MARK: UICollectionView
    
    fileprivate func snapHorizontal(){
        CollectionView.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        CollectionView.collectionViewLayout = layout
    }
    
    fileprivate func configureCollection(){
        CollectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let nib = UINib(nibName: Constant.appHeaderHorizontalCell, bundle: nil)
        CollectionView.register(nib, forCellWithReuseIdentifier: Constant.appHeaderHorizontalController)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return socials.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.appHeaderHorizontalController, for: indexPath)as! appHeaderHorizontalCell
        let socialApps  = socials[indexPath.item]
        cell.name.text = socialApps.name
        cell.discrabtion.text = socialApps.tagline
        cell.iamge.sd_setImage(with: URL(string: socialApps.imageUrl))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - 48, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right:16
        )
    }
    
}
