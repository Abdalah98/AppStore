//
//  TodayItem.swift
//  AppStoreJSONApis
//
//  Created by Brian Voong on 3/1/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit

struct TodayItem {
    
    let category: String
    let title: String
    let image: UIImage
    let description: String
    let backgroundColor: UIColor
    let cellType:CellType
    enum CellType:String{
        case single,multiple
    }
    let apps:[FeedResult]

}
