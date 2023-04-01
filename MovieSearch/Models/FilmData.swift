//
//  FilmData.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 31.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct FilmData: Codable {
    let trackId: String
    let trackCensoredName: String
    let releaseDate: String
    let primaryGenreName: String
    let artworkUrl100: String
    let country: String
    let artistName: String
    let longDescription: String
}
