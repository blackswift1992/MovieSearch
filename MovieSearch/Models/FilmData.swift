//
//  FilmData.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 31.03.2023.
//

import Foundation
import FirebaseFirestoreSwift
import RealmSwift

class FilmData: Object, Codable {
    @Persisted var trackId: String
    @Persisted var trackCensoredName: String
    @Persisted var releaseDate: String
    @Persisted var primaryGenreName: String
    @Persisted var artworkUrl100: String
    @Persisted var country: String
    @Persisted var artistName: String
    @Persisted var longDescription: String
    
    
    convenience init(trackId: String, trackCensoredName: String, releaseDate: String, primaryGenreName: String, artworkUrl100: String, country: String, artistName: String, longDescription: String) {
        self.init()
        self.trackId = trackId
        self.trackCensoredName = trackCensoredName
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
        self.artworkUrl100 = artworkUrl100
        self.country = country
        self.artistName = artistName
        self.longDescription = longDescription
    }
}
