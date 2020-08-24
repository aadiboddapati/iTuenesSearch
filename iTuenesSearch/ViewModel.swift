//
//  ViewModel.swift
//  iTuenesSearch
//
//  Created by chiranjeevi macharla on 23/08/20.
//  Copyright © 2020 Adinarayana. All rights reserved.
//

import Foundation
import UIKit

struct AlbumModel: Codable {
     let resultCount: Int
     let results: [Result]?
}

struct Result:Codable, Equatable {
        let wrapperType:String?
        let kind:String?
        let artistId:Double?
        let collectionId:Double?
        let trackId:Double?
        let artistName:String?
        let collectionName:String?
        let trackName:String?
        let collectionCensoredName:String?
        let trackCensoredName:String?
        let artistViewUrl:String?
        let collectionViewUrl:String?
        let trackViewUrl:String?
        let previewUrl:String?
        let artworkUrl30:String?
        let artworkUrl60:String?
        let artworkUrl100:String?
        let collectionPrice:Double?
        let trackPrice:Double?
        var releaseDate:String?
        let collectionExplicitness:String?
        let trackExplicitness:String?
        let discCount:Int?
        let discNumber:Int?
        let trackCount:Int?
        let trackNumber:Int?
        let trackTimeMillis:Double?
        let country:String?
        let currency:String?
        let primaryGenreName:String?
        let contentAdvisoryRating:String?
        let isStreamable:Bool?
    
}

class Album {
    
    func fetchAlbums(_ api: String, _ completion: @escaping (_ response :HTTPURLResponse?, _ results : [Result]?, _ error : Error?) -> Void)   {
        Networkmanager.shared().getApiApiWithParmeters(apiName: api, httpType: .GET) { (response, data, error) in
            if error == nil {
                do {
                let albumModel =  try JSONDecoder().decode(AlbumModel.self, from: data!)
                
                    if var _albums = albumModel.results, _albums.count > 0 {
                    // remove duplicates
                    _albums = _albums.removeDuplicates(by: \.trackName)
                    
                    // sort based on date
                    _albums =   _albums.sorted { (item1, item2) -> Bool in
                        let (date1, _) = convertStringToDate(dateString: item1.releaseDate ?? "")
                        let (date2, _) = convertStringToDate(dateString: item2.releaseDate ?? "")
                        return date1.compare(date2) == .orderedAscending
                    }
                        completion(response, _albums, error)

                    } else {
                        completion(response, nil, error)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            } else {
                completion(response,nil,error)
            }
        }
        
    }

}



