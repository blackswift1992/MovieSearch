//
//  MainViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit
import Alamofire
import SwiftyJSON
//import SDWebImage

class MainViewController: UITableViewController {
    
    private let iTunesSearchApiURL = "https://itunes.apple.com/search"
    private var allFilms = [FilmData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
        
        requestInfo()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.filmNibIdentifier, for: indexPath)
        
        guard let filmCell = cell as? FilmTableViewCell else { return UITableViewCell() }
        
        let currentFilm = allFilms[indexPath.row]
        
        filmCell.setFilmData(name: currentFilm.trackCensoredName, year: currentFilm.releaseDate, genre: currentFilm.primaryGenreName, posterURL: currentFilm.artworkUrl100)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.Segue.mainToFilmInfo, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func requestInfo() {
//        let parameters : [String:String] = [
//            "term=" : "romance",
//            "entity" : "movie",
//            "attribute" : "genreTerm",
//            "limit" : "5",
//        ]
        
        let limit = 25
        
        let parameters : [String:String] = [
            "term=" : "",
            "entity" : "movie",
            "media" : "movie",
            "attribute" : "movieTerm",
            "limit" : String(limit),
        ]

        Alamofire.request(iTunesSearchApiURL, method: .get, parameters: parameters).responseJSON { [weak self] response in
            switch response.result {
            case .success(let flower):
                let flowerJSON = JSON(flower)
                self?.allFilms.removeAll()
                
                var receivedFilms = [FilmData]()
                
                for i in 0..<limit {
                    let trackCensoredName = flowerJSON["results"][i]["trackCensoredName"].stringValue
                    let releaseDate = flowerJSON["results"][i]["releaseDate"].stringValue
                    let primaryGenreName = flowerJSON["results"][i]["primaryGenreName"].stringValue
                    let artworkUrl100 = flowerJSON["results"][i]["artworkUrl100"].stringValue
                    let country = flowerJSON["results"][i]["country"].stringValue
                    let artistName = flowerJSON["results"][i]["artistName"].stringValue
                    let shortDescription = flowerJSON["results"][i]["shortDescription"].stringValue

                    let film = FilmData(trackCensoredName: trackCensoredName, releaseDate: releaseDate, primaryGenreName: primaryGenreName, artworkUrl100: artworkUrl100, country: country, artistName: artistName, shortDescription: shortDescription)

                    receivedFilms.append(film)
                }
                
                self?.allFilms = receivedFilms
                
                self?.tableView.reloadData()
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
