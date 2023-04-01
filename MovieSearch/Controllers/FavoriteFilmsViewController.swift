//
//  FavoriteFilmsViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 01.04.2023.
//

import UIKit
import RealmSwift

class FavoriteFilmsViewController: UITableViewController {
    private let realm = try! Realm()
    
    private var favoriteFilms: Results<FilmDataRealmObject>?

    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavoriteFilmsFromRealm()
        tableView.reloadData()
    }

    // MARK: -- table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFilms?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.filmNibIdentifier, for: indexPath)
        
        guard let filmCell = cell as? FilmTableViewCell,
              let currentFilm = favoriteFilms?[indexPath.row].data
        else { return UITableViewCell() }
        
        filmCell.setFilmData(currentFilm)
        filmCell.hideStarButton()
        
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
        favoriteFilms = realm.objects(FilmDataRealmObject.self)
    }
}


//MARK: - Set up methods


private extension FavoriteFilmsViewController {
    func registerTableViewNibs() {
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
    }
}
