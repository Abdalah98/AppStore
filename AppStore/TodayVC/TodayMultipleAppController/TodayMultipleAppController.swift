//
//  TodayMultipleAppController.swift
//  AppStore
//
//  Created by Abdalah Omar on 12/6/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

enum Mode {
    case fullscreen , small
}

class TodayMultipleAppController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var apps = [FeedResult]()
    fileprivate let mode:Mode
    //to hide StatusBar
    override var prefersStatusBarHidden: Bool {return true}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.register(MultipleAppCell.self, forCellWithReuseIdentifier: "TodayMultipleApp")
        snapHorizontal()
        collectionView.backgroundColor = .systemBackground
        if mode == .fullscreen{
            setupButton()
            navigationController?.isNavigationBarHidden = true
            
        }else{
            collectionView.isScrollEnabled = false
        }
        
    }
    
    init(mode:Mode) {
        self.mode = mode
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func snapHorizontal(){
        collectionView.decelerationRate = .fast
        let layout = BetterSnappingLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    
    let closeButton:UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "close_button"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handelDismiss), for: .touchUpInside)
        return button
    }()
    
    @objc func handelDismiss(){
        dismiss(animated: true)
    }
    
    func setupButton(){
        view.addSubview(closeButton)
        closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 20, left: 0, bottom: 0, right: 16),size: .init(width: 44, height: 44))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mode == .fullscreen{
            return apps.count
        }
        return min(4,apps.count)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayMultipleApp", for: indexPath) as! MultipleAppCell
        cell.app = apps[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let height= (view.frame.height - 3 * 16) / 4
        if mode == .fullscreen{
            return CGSize.init(width: view.frame.width - 48, height: 74)
        }
        return CGSize.init(width: view.frame.width , height:(view.frame.height - 3 * 16) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullscreen{
            return UIEdgeInsets(top: 20, left: 24, bottom: 12, right: 24)
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appId = self.apps[indexPath.item].id
        let appDetailController = AppDetailsController(collectionViewLayout: UICollectionViewFlowLayout())
        appDetailController.appId = appId
        appDetailController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(appDetailController, animated: true)
    }
}
