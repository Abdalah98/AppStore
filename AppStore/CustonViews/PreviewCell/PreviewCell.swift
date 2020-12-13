//
//  PreviewCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/23/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
class PreviewCell: UICollectionViewCell {
    @IBOutlet weak var PreviewScreenshotsController: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        PreviewScreenshotsController.dataSource = self
        PreviewScreenshotsController.delegate = self
        configureCollection()
        snapHorizontal()
        
    }
    var app:Result?{
        didSet{
            self.PreviewScreenshotsController.reloadData()
            
        }
    }
}

extension PreviewCell : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    fileprivate func configureCollection(){
        PreviewScreenshotsController.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        let nib = UINib(nibName: Constant.ScreenshotCell, bundle: nil)
        PreviewScreenshotsController.register(nib, forCellWithReuseIdentifier: Constant.Screenshot)
        
    }
    
    fileprivate func snapHorizontal(){
        PreviewScreenshotsController.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        PreviewScreenshotsController.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .horizontal
        PreviewScreenshotsController.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Screenshot, for: indexPath) as! ScreenshotCell
        let screenshotUrl = self.app?.screenshotUrls[indexPath.item] ?? ""
        cell.screenshotsImageView.sd_setImage(with: URL(string: screenshotUrl ))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 250, height: 456)
    }
    
}

