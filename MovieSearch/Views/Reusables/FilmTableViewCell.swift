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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setFilmData(name: String, year: String, genre: String, posterURL: String) {
        posterImageView.sd_setImage(with: URL(string: posterURL))
        nameLabel.text = name
        yearLabel.text = year
        genreLabel.text = genre
    }
    
}
