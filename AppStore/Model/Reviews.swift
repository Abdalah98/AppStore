//
//  Reviews.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/23/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import Foundation

struct Reviews:Codable {
    let feed    : ReviewFeed
}

struct ReviewFeed:Codable {
    let entry   : [Entry]
}


struct Entry:Codable {
    let author  : Author
    let title   : Label
    let content : Label
    let rating  :Label
    
    enum CodingKeys :String,CodingKey {
        case author,title,content
        case rating = "im:rating"
    }
}


struct Author:Codable {
   let  name    : Label
}


struct Label:Codable {
    let label   : String
}
