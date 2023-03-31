//
//  MainViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit
//import Alamofire
//import SwiftyJSON

class MainViewController: UITableViewController {
    
//    private let iTunesSearchApiURL = "https://itunes.apple.com/search"
    private let iTunesDataProvider = ITunesDataProvider()
    private var allFilms = [FilmData]()
    private var selectedFilm: FilmData?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
        iTunesDataProvider.delegate = self
        
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
        selectedFilm = allFilms[indexPath.row]
        performSegue(withIdentifier: K.Segue.mainToFilmInfo, sender: self)
        selectedFilm = nil
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: -- preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.mainToFilmInfo {
            if let destinationVC = segue.destination as? FilmInfoViewController {
                    destinationVC.setFilmData(selectedFilm)
            }
        }
    }
    
    
    func requestInfo() {
        allFilms.removeAll()
        
        let parameters : [String:String] = [
            "term=" : "",
            "entity" : "movie",
            "media" : "movie",
            "attribute" : "movieTerm",
            "limit" : String(25),
        ]
        
        iTunesDataProvider.fetchFilmsData(parameters: parameters)
    }
}



extension MainViewController: ITunesDataProviderDelegate {
    func processFetchedFilmsData(_ provider: ITunesDataProvider, filmsData: [FilmData]) {
        allFilms = filmsData
        tableView.reloadData()
    }
}
