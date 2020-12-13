//
//  LanguageRow.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/24/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class LanguageRow: UICollectionViewCell {
    
    
    @IBOutlet weak var LanguageRowCollection: UICollectionView!
    var app:Result?{
        didSet{
            self.LanguageRowCollection.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollection()
        LanguageRowCollection.dataSource = self
        LanguageRowCollection.delegate = self
        LanguageRowCollection.contentInset = .init(top: 0, left:16, bottom: 0, right: 16)
        
    }
}

extension LanguageRow : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    fileprivate func configureCollection(){
        let nib = UINib(nibName: Constant.LanguageCell, bundle: nil)
        LanguageRowCollection.register(nib, forCellWithReuseIdentifier: Constant.LanguageNib)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.languageCodesISO2A.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.LanguageNib, for: indexPath) as! LanguageCell
        let language = self.app?.languageCodesISO2A[indexPath.item] ?? ""
        cell.languageLabel.text = language
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 25, height: 25)
    }
    
}

