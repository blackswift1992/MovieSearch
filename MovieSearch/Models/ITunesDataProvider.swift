//
//  ITunesDataProvider.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 31.03.2023.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ITunesDataProviderDelegate: AnyObject {
    func processFetchedFilmsData(_ provider: ITunesDataProvider, filmsData: [FilmData])
}

class ITunesDataProvider {
    weak var delegate: ITunesDataProviderDelegate?

    private let iTunesSearchApiURL = "https://itunes.apple.com/search"
    let itunesDefaultLimit = "50"
    
    func fetchFilmsData(parameters : [String:String]){
        
        
        guard let _ = delegate,
              let limit = Int(parameters["limit"] ?? itunesDefaultLimit) else {
            return
        }
        
        Alamofire.request(iTunesSearchApiURL, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let safeSelf = self else { return }
            
            switch response.result {
            case .success(let flower):
                let flowerJSON = JSON(flower)
                
                var fetchedFilmsData = [FilmData]()
                
                for i in 0..<limit {
                    let trackCensoredName = flowerJSON["results"][i]["trackCensoredName"].stringValue
                    let releaseDate = flowerJSON["results"][i]["releaseDate"].stringValue
                    let primaryGenreName = flowerJSON["results"][i]["primaryGenreName"].stringValue
                    let artworkUrl100 = flowerJSON["results"][i]["artworkUrl100"].stringValue
                    let country = flowerJSON["results"][i]["country"].stringValue
                    let artistName = flowerJSON["results"][i]["artistName"].stringValue
                    let longDescription = flowerJSON["results"][i]["longDescription"].stringValue
                    
                    let film = FilmData(trackCensoredName: trackCensoredName, releaseDate: releaseDate, primaryGenreName: primaryGenreName, artworkUrl100: artworkUrl100, country: country, artistName: artistName, longDescription: longDescription)
                    
                    fetchedFilmsData.append(film)
                }
                
                self?.delegate?.processFetchedFilmsData(safeSelf, filmsData: fetchedFilmsData)
            case .failure(let error):
                print(error)
            }
        }
    }
}

