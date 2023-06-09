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
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var filmData: FilmData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}


//MARK: - Public methods


extension FilmInfoViewController {
    func setFilmData(_ data: FilmData?) {
        filmData = data
    }
}


//MARK: - @IBAction


private extension FilmInfoViewController {
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        if let safeFilmData = filmData {
            let items : [Any] = ["https://itunes.apple.com/search?term=\(safeFilmData.trackCensoredName.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))&entity=movie&media=movie&attribute=movieTerm&limit=1"]
            
            let avc = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self.present(avc, animated: true)
        }
    }
}
//MARK: - Set up methods


private extension FilmInfoViewController {
    func customizeUIElements() {
        if let safeFilmData = filmData {
            filmNameLabel.text = safeFilmData.trackCensoredName
            posterImageView.sd_setImage(with: URL(string: safeFilmData.artworkUrl100))
            yearLabel.text = String(safeFilmData.releaseDate.prefix(4))
            countryLabel.text = safeFilmData.country
            genreLabel.text = safeFilmData.primaryGenreName
            directorNameLabel.text = safeFilmData.artistName
            descriptionLabel.text = safeFilmData.longDescription
        }
    }
}
