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
import RealmSwift

class FilmTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    @IBOutlet private weak var heartButtonView: UIView!
    @IBOutlet private weak var heartButton: UIButton!
    
    private let realm = try! Realm()
    
    private var filmData: FilmData?
    private var isStarButtonTapped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        let image = UIImage(systemName: "heart")
        heartButton.setImage(image, for: .normal)
        
        isStarButtonTapped = false
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
    }
    
    func hideStarButton() {
        heartButtonView.isHidden = true
    }
}


//MARK: - @IBActions


private extension FilmTableViewCell {
    @IBAction func starTapped(_ sender: UIButton) {
        if !isStarButtonTapped && filmData != nil {
            isStarButtonTapped = true
            let image = UIImage(systemName: "heart.fill")
            
            heartButton.setImage(image, for: .normal)
            
            print("qqqqqqq")
            
            
            
            //записати FilmData в Firebase i потім в Realm
            //для цього в FilmTableViewCell треба передавати цілий об'єкт FilmData
            if let safeFilmData = filmData {
                uploadFilmData(safeFilmData)
            } else {
                isStarButtonTapped = false
                
                let image = UIImage(systemName: "heart")
                heartButton.setImage(image, for: .normal)
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
                    if error != nil {
                        print(error!)
                    } else {
                        self?.saveFilmDataToRealm(FilmDataRealmObject(data: filmData))
                    }
                }
            }
        } catch let error {
            print("Error writing film data to Firestore: \(error)")
        }
    }
    
    func saveFilmDataToRealm(_ data: FilmDataRealmObject) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
            }
        } catch {
            print("Error with appUser saving, \(error)")
        }
    }
}
