//
//  AppsHorizontalController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/20/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import SDWebImage

extension AppsGroubCell :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        AppGroupcollectionView.dataSource = self
        AppGroupcollectionView.delegate = self
        snapHorizontal()
        configureCollection()
    }
    
    // MARK: UICollectionView
    fileprivate func configureCollection(){
        AppGroupcollectionView.contentInset = .init(top: 12, left: 16, bottom: 12, right: 16)
        let nib = UINib(nibName: Constant.AppsHorizontalCellXib, bundle: nil)
        AppGroupcollectionView.register(nib, forCellWithReuseIdentifier: Constant.AppsHorizontal)
        
    }
   
    fileprivate func snapHorizontal(){
        AppGroupcollectionView.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        AppGroupcollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroub?.feed.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.AppsHorizontal, for: indexPath) as! AppsHorizontalCellXib
        let app = appGroub?.feed.results[indexPath.item]
        cell.appName.text = app?.name
        cell.companyName.text = app?.artistName
        cell.imageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (frame.height - 2 * topBottomPadding - 2 * lineSpacing) / 4
        let width  = frame.width - 48
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
           if let  app = appGroub?.feed.results[indexPath.item]{
               didSelectHeader?(app)
           }
       }
    
}


