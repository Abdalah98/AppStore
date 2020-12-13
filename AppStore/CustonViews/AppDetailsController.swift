//
//  AppDetailsController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/22/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import SDWebImage

class AppDetailsController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    var appId:String!{
        didSet{
            fetchData()
        }
    }
    
    var app:Result?
    var reviews:Reviews?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        snapHorizontal()
        navigationController?.navigationBar.prefersLargeTitles = false
        configureAppDetailsCell()
        configurePreviewCell()
        configureReviewRowCell()
        configureInformationCell()
        configuresupportedDevicesRowCell()
        configureLanguageRowCell()
    }
    
    // call api
    fileprivate  func fetchData() {
        let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
        NetworkManger.shared.fetchGenericJSONData(urlString: urlString) { (result:SearchResult?, err) in
            let app = result?.results.first
            DispatchQueue.main.async {
                self.app = app
                self.collectionView.reloadData()
            }
        }
        
        let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId ?? "")/sortby=mostrecent/json?l=en&cc=us"
        print(reviewsUrl)
        NetworkManger.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews:Reviews?, err) in
            self.reviews = reviews
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // call nib
    fileprivate func configureAppDetailsCell(){
        collectionView.backgroundColor = .systemBackground
        let nib = UINib(nibName: Constant.AppDetailsCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.AppDetails)
    }
    
    fileprivate func configurePreviewCell(){
        let nib = UINib(nibName: Constant.PreviewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.Preview)
    }
    
    fileprivate func configureReviewRowCell(){
        let nib = UINib(nibName:Constant.ReviewRowCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:Constant.ReviewRow)
    }
    
    fileprivate func configureInformationCell(){
        let nib = UINib(nibName:Constant.InformationRow, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:Constant.InformationCell)
    }
    
    fileprivate func configuresupportedDevicesRowCell(){
        let nib = UINib(nibName:Constant.supportedDevicesRow, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:Constant.supportedDevices)
    }
    
    fileprivate func configureLanguageRowCell(){
        let nib = UINib(nibName:Constant.LanguageRow, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier:Constant.Language)
    }
    fileprivate func snapHorizontal(){
        // collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    // MARK: UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.AppDetails, for: indexPath) as! AppDetailsCell
            cell.app = app
            return cell
            
        }else if indexPath.item == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.Preview, for: indexPath) as! PreviewCell
            cell.app = self.app
            return cell
        }else if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constant.ReviewRow, for: indexPath) as! ReviewRowCell
            cell.reviews = self.reviews
            return cell
        }else if indexPath.item == 3{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constant.InformationCell, for: indexPath) as! InformationRow
            cell.app = self.app
            return cell
        }else if indexPath.item == 4{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constant.Language, for: indexPath) as!  LanguageRow
            cell.app = self.app
            return cell
            
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:Constant.supportedDevices, for: indexPath) as! supportedDevicesRow
            cell.app = self.app
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //refuctor
        
        var height :CGFloat = 300
        if indexPath.item == 0{
            
            let dummyCell = AppDetailsCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 300))
            
            //  dummyCell.app = self.app
            dummyCell.nameLabel?.text = self.app?.trackName
            dummyCell.releaseNoteLabel?.text = self.app?.releaseNotes
            dummyCell.AboutLabel?.text = self.app?.primaryGenreName
            dummyCell.sellerName?.text = self.app?.sellerName
            dummyCell.imageView?.sd_setImage(with: URL(string: self.app?.artworkUrl100 ?? ""))
            dummyCell.priceButton?.setTitle(self.app?.formattedPrice, for: .normal)
            //updata all hight if needed
            dummyCell.layoutIfNeeded()
            
            //custom  label hight
            let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 300))
            height = estimatedSize.height
            self.collectionView.reloadData()
        }else if indexPath.item == 1{
            height = 500
            
        }else if indexPath.item == 2{
            //refuctor
            height = 300
            
        }else if indexPath.item == 3{
            height = 321
        }else if indexPath.item == 4{
            height = 200
        }else{
            height = 200
        }
        return CGSize(width: view.frame.width, height:height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
    }
    
}
