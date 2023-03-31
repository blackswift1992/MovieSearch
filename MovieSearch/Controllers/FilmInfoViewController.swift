//
//  FilmInfoViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit

class FilmInfoViewController: UIViewController {
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var directorNameLabel: UILabel!
    @IBOutlet private weak var shortDescriptionLabel: UILabel!
    
    private var filmData: FilmData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUIElements()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    func setFilmData(_ data: FilmData?) {
        filmData = data
    }
    
    private func customizeUIElements() {
        if let safeFilmData = filmData {
            filmNameLabel.text = safeFilmData.trackCensoredName
            posterImageView.sd_setImage(with: URL(string: safeFilmData.artworkUrl100))
            yearLabel.text = String(safeFilmData.releaseDate.prefix(4))
            countryLabel.text = safeFilmData.country
            genreLabel.text = safeFilmData.primaryGenreName
            directorNameLabel.text = safeFilmData.artistName
            shortDescriptionLabel.text = safeFilmData.longDescription
        }
    }
}
