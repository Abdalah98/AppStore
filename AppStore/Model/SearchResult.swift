//
//  SearchResult.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/19/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import Foundation
struct SearchResult :Codable{
    let resultCount     :Int
    let results         :[Result]
}

struct Result:Codable {
    let trackId                     :Int
    let trackName                   :String
    let primaryGenreName            :String
    var averageUserRating           :Float?
    let screenshotUrls              :[String]
    let artworkUrl100               :String
    let formattedPrice              :String?
    let description                 :String
    var releaseNotes                :String?
            
    let supportedDevices            :[String]
    let languageCodesISO2A          :[String]
    let contentAdvisoryRating       :String
    let sellerUrl                   :String?
    let sellerName                  :String
    let fileSizeBytes               :String
    let releaseDate                 :String
}


