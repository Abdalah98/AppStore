//
//  AppSearchController.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/18/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit
import SDWebImage

class AppSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    
    var appResult           = [Result]()
    var timer :Timer?
    let searchController    = UISearchController()
    
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearch()
        configureCollection()
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
    }
    
    
    fileprivate func configureCollection(){
        let nib = UINib(nibName: Constant.SearchResultCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constant.appSearchCell)
        
    }
    
    // MARK: UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return appResult.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.appSearchCell, for: indexPath) as! SearchResultCell
        cell.appResults = appResult[indexPath.item]
        return cell
    }
    //MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AppDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
        vc.appId = String(appResult[indexPath.item].trackId)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}


//MARK: - SearchController
extension AppSearchController:UISearchBarDelegate, UISearchControllerDelegate{
    fileprivate func configureSearch() {
        searchController.searchBar.placeholder = "Search Here"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            NetworkManger.shared.fetchApp(searchTrem: searchText) { (res, error) in
                if let error = error{
                    print("Failed to fetch apps",error)
                    return
                }
                self.appResult = res?.results ?? []
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    
                }
            }
        })
    }
    
}
