//
//  FilmTableViewCell.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore
import SwipeCellKit

class FilmTableViewCell: SwipeTableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    @IBOutlet private weak var heartButtonView: UIView!
    @IBOutlet private weak var heartButton: UIButton!
    
    private let realmManager = RealmManager()
    
    private var filmData: FilmData?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        let image = UIImage.heart
        heartButton.setImage(image, for: .normal)
    }
}


//MARK: - Public methods


extension FilmTableViewCell {
    func setFilmData(_ data: FilmData) {
        filmData = data
        posterImageView.sd_setImage(with: URL(string: data.artworkUrl100))
        nameLabel.text = data.trackCensoredName
        yearLabel.text = String(data.releaseDate.prefix(4))
        genreLabel.text = data.primaryGenreName

        if realmManager.checkIsFavorite(filmId: data.trackId) {
            let image = UIImage.heartFill
            heartButton.setImage(image, for: .normal)
        }
    }
    
    func hideHeartButton() {
        heartButtonView.isHidden = true
    }
}


//MARK: - @IBActions


private extension FilmTableViewCell {
    @IBAction func heartTapped(_ sender: UIButton) {
        if let safeFilmData = filmData {
            if !realmManager.checkIsFavorite(filmId: safeFilmData.trackId) {
                let image = UIImage.heartFill
                heartButton.setImage(image, for: .normal)
                
                uploadFilmData(safeFilmData)
            }
        }
    }
}


//MARK: - Private methods


private extension FilmTableViewCell {
    func uploadFilmData(_ filmData: FilmData) {
        guard let safeUserId = Auth.auth().currentUser?.uid else { return }
        
        do {
            try Firestore.firestore().collection(safeUserId + K.FStore.favoriteFilms).document(filmData.trackId).setData(from: filmData) { [weak self] error in
                DispatchQueue.main.async {
                    if let safeError = error {
                        print(safeError)
                    } else {
                        if let safeSelf = self {
                            let isSuccessResult = safeSelf.realmManager.saveFilmDataContainerToRealm(FilmDataContainer(data: filmData))
                            
                            if !isSuccessResult {
                                safeSelf.setDefaultImageToHeartButton()
                            }
                        }
                    }
                }
            }
        } catch let error {
            print("Error with favorite film data saving to Firestore, \(error)")
        }
    }

    func setDefaultImageToHeartButton() {
        let image = UIImage.heart
        heartButton.setImage(image, for: .normal)
    }
}
