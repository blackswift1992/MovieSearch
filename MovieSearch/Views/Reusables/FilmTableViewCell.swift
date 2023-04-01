//
//  FilmTableViewCell.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 30.03.2023.
//

import UIKit
import SDWebImage

class FilmTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    
    @IBOutlet weak var starButtonView: UIView!
    @IBOutlet weak var starImageView: UIImageView!
    
    private var filmData: FilmData?
    private var isStarButtonTapped = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
        starButtonView.isHidden = true
    }
}


//MARK: - @IBActions


private extension FilmTableViewCell {
    @IBAction func starTapped(_ sender: UIButton) {
        if !isStarButtonTapped && filmData != nil {
            isStarButtonTapped = true
            starImageView.image = UIImage(systemName: "star.fill")
            print("qqqqqqq")
            
            //записати FilmData в Firebase i потім в Realm
            //для цього в FilmTableViewCell треба передавати цілий об'єкт FilmData
        }
    }
}
