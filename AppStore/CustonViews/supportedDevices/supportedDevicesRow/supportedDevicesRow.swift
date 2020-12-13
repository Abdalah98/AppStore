//
//  supportedDevicesRow.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/24/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class supportedDevicesRow: UICollectionViewCell {
    @IBOutlet weak var supportedDevicesCollection: UICollectionView!
    var app:Result?{
        didSet{
            self.supportedDevicesCollection.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
        supportedDevicesCollection.dataSource = self
        supportedDevicesCollection.delegate = self
        supportedDevicesCollection.contentInset = .init(top: 0, left:16, bottom: 0, right: 16)

    }

}

extension supportedDevicesRow : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
     fileprivate func configureCollection(){
         let nib = UINib(nibName: Constant.supportedDevicesCell, bundle: nil)
         supportedDevicesCollection.register(nib, forCellWithReuseIdentifier: Constant.supportedDevicesNib)
         
     }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.supportedDevices.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.supportedDevicesNib, for: indexPath) as! supportedDevicesCell
        let supportedDevices = self.app?.supportedDevices[indexPath.item] ?? ""
        cell.supportedDevicesLabel.text = supportedDevices
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 340 , height: 25)
    }

      }

