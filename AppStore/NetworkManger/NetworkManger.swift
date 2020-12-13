//
//  NetworkManger.swift
//  AppStore
//
//  Created by Abdalah Omar on 11/19/20.
//  Copyright © 2020 Abdallah. All rights reserved.
//

import Foundation
class NetworkManger{
    
    static let shared = NetworkManger()
    
    func fetchApp(searchTrem:String,completion: @escaping(SearchResult?,Error?)-> Void){
        let urlString           = "https://itunes.apple.com/search?term=\(searchTrem)&entity=software"
        // fetch data from internet
        fetchGenericJSONData(urlString: urlString, completion: completion)
        
    }
    
    
    func fetchAppGroups(url:String,completion: @escaping(AppGroup?,Error?)-> Void){
        fetchGenericJSONData(urlString: url, completion: completion)
    }
    
    
    func topFree(completion: @escaping(AppGroup?,Error?)-> Void){
        let url = "https://rss.itunes.apple.com/api/v1/eg/ios-apps/top-free/all/50/explicit.json"
        fetchAppGroups(url: url, completion: completion)
    }
    
    
    func topGrossing(completion: @escaping(AppGroup?,Error?)-> Void){
        let url = "https://rss.itunes.apple.com/api/v1/eg/ios-apps/top-grossing/all/50/explicit.json"
        fetchAppGroups(url: url, completion: completion)
    }
    
    
    func newAppsWeLove(completion: @escaping(AppGroup?,Error?)-> Void){
        let url = "https://rss.itunes.apple.com/api/v1/eg/ios-apps/new-apps-we-love/all/50/explicit.json"
        fetchAppGroups(url: url, completion: completion)
    }
    
    
    func newGamesWeLove(completion: @escaping(AppGroup?,Error?)-> Void){
        let url = "https://rss.itunes.apple.com/api/v1/eg/ios-apps/new-games-we-love/all/50/explicit.json"
        fetchAppGroups(url: url, completion: completion)
    }
    
    // fetch data to header
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
    
    //declare my generic json function here
    
    func fetchGenericJSONData<T:Codable>(urlString:String,completion: @escaping (T?, Error?) -> Void){
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            guard let response  = response as? HTTPURLResponse ,response.statusCode == 200 else {
                completion(nil,nil)
                
                return
            }
            guard let data = data else { return }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                // success
                completion(objects, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
}


