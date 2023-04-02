//
//  MainViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit

class MainViewController: UITableViewController {
    private let searchController = UISearchController()
    
    private let iTunesDataProvider = ITunesDataProvider()
    private var allFilms = [FilmData]()
    private var selectedFilm: FilmData?
    private var timer: Timer?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        iTunesDataProvider.delegate = self
        
        registerTableViewNibs()
        setUpSearchController()
        requestInfo()
    }

    // MARK: -- table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.TableCell.filmNibIdentifier, for: indexPath)
        guard let filmCell = cell as? FilmTableViewCell else { return UITableViewCell() }
        
        let film = allFilms[indexPath.row]
        filmCell.setFilmData(film)
        
        return cell
    }
    
    // MARK: -- table view delegate
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
}


//MARK: - Protocols



//MARK: -- ITunesDataProviderDelegate
extension MainViewController: ITunesDataProviderDelegate {
    func processFetchedFilmsData(_ provider: ITunesDataProvider, filmsData: [FilmData]) {
        allFilms = filmsData
        tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate


extension MainViewController: UISearchBarDelegate  {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        let parameters = getRequestParameters(byFilmName: K.Case.emptyString, limit: 50)
        iTunesDataProvider.fetchFilmsData(parameters: parameters)
    }
}


//MARK: - Private methods


private extension MainViewController {
    func requestInfo() {
        let parameters = getRequestParameters(byFilmName: K.Case.emptyString, limit: 50)
        iTunesDataProvider.fetchFilmsData(parameters: parameters)
    }
    
    func getRequestParameters(byFilmName name: String, limit: Int) -> [String:String] {
        let parameters : [String:String] = [
            "term" : name,
            "entity" : "movie",
            "media" : "movie",
            "attribute" : "movieTerm",
            "limit" : String(limit)
        ]
        
        return parameters
    }
    
    @objc func textDidChange() {
        timer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let searchText = self?.searchController.searchBar.searchTextField.text,
                  let safeSelf = self
            else { return }
            
            if !searchText.isEmpty {
                let parameters = safeSelf.getRequestParameters(byFilmName: searchText, limit: 50)
                safeSelf.iTunesDataProvider.fetchFilmsData(parameters: parameters)
                return
            }
            
            let parameters = safeSelf.getRequestParameters(byFilmName: K.Case.emptyString, limit: 50)
            safeSelf.iTunesDataProvider.fetchFilmsData(parameters: parameters)
        }
    }
}


//MARK: - Set up methods


private extension MainViewController {
    func setUpSearchController() {
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        
        searchController.searchBar.searchTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func registerTableViewNibs() {
        tableView.register(UINib(nibName: K.TableCell.filmNibName, bundle: nil), forCellReuseIdentifier: K.TableCell.filmNibIdentifier)
    }
}
