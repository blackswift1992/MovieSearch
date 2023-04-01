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
    private let iTunesSearchApiURL = "https://itunes.apple.com/search"
    
    weak var delegate: ITunesDataProviderDelegate?
}


//MARK: - Public methods


extension ITunesDataProvider {
    func fetchFilmsData(parameters : [String:String]){
        Alamofire.request(iTunesSearchApiURL, method: .get, parameters: parameters).responseJSON { [weak self] response in
            guard let safeSelf = self else { return }
            
            switch response.result {
            case .success(let filmsData):
                var fetchedFilmsData = [FilmData]()
                
                let filmsDataJSON = JSON(filmsData)

                guard let resultCount = Int(filmsDataJSON["resultCount"].stringValue) else { return }
                
                for i in 0..<resultCount {
                    let trackCensoredName = filmsDataJSON["results"][i]["trackCensoredName"].stringValue
                    let releaseDate = filmsDataJSON["results"][i]["releaseDate"].stringValue
                    let primaryGenreName = filmsDataJSON["results"][i]["primaryGenreName"].stringValue
                    let artworkUrl100 = filmsDataJSON["results"][i]["artworkUrl100"].stringValue
                    let country = filmsDataJSON["results"][i]["country"].stringValue
                    let artistName = filmsDataJSON["results"][i]["artistName"].stringValue
                    let longDescription = filmsDataJSON["results"][i]["longDescription"].stringValue
                    
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
