//
//  AppsController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/20/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class AppsPageController: UICollectionViewController ,UICollectionViewDelegateFlowLayout{
    
    
    var groups = [AppGroup]()
    var socialApps = [SocialApp]()
    let activity: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.style = .large
        aiv.color = .label
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        configureCollectionFooter()
        configureCollectionHeader()
        fetchData()
        view.addSubview(activity)
        activity.fillSuperview()
    }
    
    fileprivate func fetchData(){
        activity.startAnimating()
        var group1 :AppGroup?
        var group2 :AppGroup?
        var group3 :AppGroup?
        var group4 :AppGroup?
        
        //help you sync your data fetches  all cell together
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        NetworkManger.shared.topFree { (appGroup, error) in
            dispatchGroup.leave()
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        NetworkManger.shared.topGrossing { (appGroup, error) in
            dispatchGroup.leave()
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        NetworkManger.shared.newAppsWeLove { (appGroup, error) in
            dispatchGroup.leave()
            group3 = appGroup
            
        }
        
        dispatchGroup.enter()
        NetworkManger.shared.newGamesWeLove { (appGroup, error) in
            dispatchGroup.leave()
            group4 = appGroup
            
        }
        dispatchGroup.enter()
        
        NetworkManger.shared.fetchSocialApps { (apps, err) in
            dispatchGroup.leave()
            self.socialApps = apps ?? []
            
        }
        
        //completion
        dispatchGroup.notify(queue: .main) {
            self.activity.stopAnimating()
            self.activity.hidesWhenStopped = true
            print("Completed your dispatch group tasks..")
            
            if let group = group1{
                self.groups.append(group)
            }
            if let group = group2{
                self.groups.append(group)
            }
            if let group = group3{
                self.groups.append(group)
            }
            if let group = group4{
                self.groups.append(group)
            }
            self.collectionView.reloadData()
        }
    }
    //Header
    
    fileprivate func configureCollectionHeader(){
        collectionView.register(UINib.init(nibName:  Constant.AppsPageHeaderReusableView, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constant.AppsPageHeader)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constant.AppsPageHeader, for: indexPath) as! AppsPageHeaderReusableView
        header.socials = self.socialApps
        header.CollectionView.reloadData()
        return header
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height:300)
    }
    
    
    //Footer
    // MARK: UICollectionView
    
    fileprivate func configureCollectionFooter(){
        let nib = UINib(nibName: Constant.AppsGroubCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.AppsCell)
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  Constant.AppsCell, for: indexPath) as! AppsGroubCell
        let appGroups = groups[indexPath.item]
        cell.title.text = appGroups.feed.title
        cell.appGroub = appGroups
        cell.AppGroupcollectionView.reloadData()
        cell.didSelectHeader = {[weak self] FeedResult in
            let vc = AppDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
            vc.appId = FeedResult.id
            vc.navigationItem.title = FeedResult.name
            self?.navigationController?.pushViewController(vc, animated: true)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
    }
    
}
