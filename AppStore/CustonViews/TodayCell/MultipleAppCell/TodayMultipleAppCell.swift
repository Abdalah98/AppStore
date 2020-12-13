//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Abdalah Omar on 12/6/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {
    
   override var todayItem :TodayItem!{
        didSet{
            categoryLabel.text = todayItem.category
            titleLabel.text  = todayItem.title
            multipleAppController.apps = todayItem.apps
            multipleAppController.collectionView.reloadData()
            multipleAppController.collectionView.backgroundColor = .white

        }
    }
    
    let categoryLabel = UILabel(text: "THE DAILY LIST", font: .boldSystemFont(ofSize: 20))
    let titleLabel = UILabel(text: "Test-Drive These CarPlay Apps", font: .boldSystemFont(ofSize: 32),numberOfLines: 2)
    let multipleAppController = TodayMultipleAppController(mode: .small)
    
    
    override  init( frame :CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        layer.cornerRadius = 16

        let stackView = VerticalStackView(arrangedSubviews: [categoryLabel,titleLabel,multipleAppController.view], spacing: 12)
        
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
