//
//  AppGroup.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/21/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import Foundation
struct AppGroup:Codable {
    let feed :Feed
}
struct Feed:Codable {
    let title :String
    let results :[FeedResult]
}
struct FeedResult:Codable {
    let id,name , artistName ,artworkUrl100:String
}
