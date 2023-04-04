//
//  FavoriteFilmsViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 01.04.2023.
//

import UIKit
import SwipeCellKit
import FirebaseAuth
import FirebaseFirestore
import RealmSwift

class FavoriteFilmsViewController: UITableViewController {
    private let realmManager = RealmManager()
    
    private var favoriteFilms: Results<FilmDataContainer>?
    private var selectedFilm: FilmData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewNibs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteFilms = realmManager.fetchFavoriteFilmsFromRealm()
        tableView.reloadData()
    }

    // MARK: -- table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteFilms?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.filmNibIdentifier, for: indexPath)

        if let swipeCell = cell as? SwipeTableViewCell {
            swipeCell.delegate = self
        }
        
        guard let filmCell = cell as? FilmTableViewCell,
              let film = favoriteFilms?[indexPath.row].data
        else { return UITableViewCell() }

        filmCell.setFilmData(film)
        filmCell.hideHeartButton()
        
        return cell
    }
    
    // MARK: -- table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilm = favoriteFilms?[indexPath.row].data
        performSegue(withIdentifier: K.Segue.favoriteFilmsToFilmInfo, sender: self)
        selectedFilm = nil
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: -- preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.favoriteFilmsToFilmInfo {
            if let destinationVC = segue.destination as? FilmInfoViewController {
                    destinationVC.setFilmData(selectedFilm)
            }
        }
    }
}


//MARK: - SwipeTableViewCellDelegate


extension FavoriteFilmsViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            guard let selectedFilm = self?.favoriteFilms?[indexPath.row] else { return }
            self?.deleteFilmFromFirebase(selectedFilm)
            self?.realmManager.deleteFavoriteFilmFromRealm(selectedFilm)
        }

        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}


//MARK: - Private methods


private extension FavoriteFilmsViewController {
    func deleteFilmFromFirebase(_ filmData: FilmDataContainer) {
        guard let safeUserId = Auth.auth().currentUser?.uid,
        let safeFilmData = filmData.data
        else { return }
        
        Firestore.firestore().collection(safeUserId + K.FStore.favoriteFilms).document(safeFilmData.trackId).delete { [weak self] error in
            if let safeError = error {
                print("Film deletion was failed: \(safeError)")
            }
        }
    }
}


//MARK: - Set up methods


private extension FavoriteFilmsViewController {
    func registerTableViewNibs() {
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
    }
}
