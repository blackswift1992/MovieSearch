//
//  RealmManager.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 02.04.2023.
//

import UIKit
import RealmSwift

protocol RealmManagerDelegate: AnyObject {
    func getSaveDataError(_ manager: RealmManager, errorMessage: String)
}

class RealmManager {
    private let realm = try! Realm()
    
    weak var delegate: RealmManagerDelegate?
    
    
    func saveFilmDataContainerToRealm(_ data: FilmDataContainer) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
            }
        } catch {
            delegate?.getSaveDataError(self, errorMessage: error.localizedDescription)
        }
    }
    
    func checkIsFavorite(filmId: String) -> Bool {
        let filmDataRealmobject = realm.objects(FilmDataContainer.self).filter("data.trackId == '\(filmId)'").first
        return filmDataRealmobject != nil
    }
}

