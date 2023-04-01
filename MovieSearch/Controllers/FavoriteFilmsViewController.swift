//
//  FavoriteFilmsViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 01.04.2023.
//

import UIKit

class FavoriteFilmsViewController: UITableViewController {
    private var favoriteFilms = [FilmData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewNibs()
        fetchFavoriteFilmsFromRealm()
    }

    // MARK: -- table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFilms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.filmNibIdentifier, for: indexPath)
        
        guard let filmCell = cell as? FilmTableViewCell else { return UITableViewCell() }
        
        let currentFilm = favoriteFilms[indexPath.row]
        
        filmCell.setFilmData(currentFilm)
        
        return cell
    }
    
    // MARK: -- table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - Private methods


private extension FavoriteFilmsViewController {
    func fetchFavoriteFilmsFromRealm() {
        //Type code to fetch favorite films from Realm
        
        tableView.reloadData()
    }
}


//MARK: - Set up methods


private extension FavoriteFilmsViewController {
    func registerTableViewNibs() {
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
    }
}
