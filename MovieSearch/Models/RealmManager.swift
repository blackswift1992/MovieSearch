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
    
    private var favoriteFilms: Results<FilmDataContainer>?
    
    
    func saveAppUserToRealm(_ appUser: AppUserDataContainer) {
        do {
            try realm.write {
                realm.add(appUser, update: .modified)
            }
        } catch {
            print("Error with AppUserDataContainer saving to Realm, \(error)")
        }
    }
    
    func saveFavoriteFilmDataToRealm(_ film: FilmDataContainer) {
        do {
            try realm.write {
                realm.add(film, update: .modified)
            }
        } catch {
            print("Error with FilmDataContainer saving to Realm, \(error)")
        }
    }
    
    func saveFilmDataContainerToRealm(_ data: FilmDataContainer) {
        do {
            try realm.write {
                realm.add(data, update: .modified)
            }
        } catch {
            delegate?.getSaveDataError(self, errorMessage: error.localizedDescription)
        }
    }
    
    func fetchFavoriteFilmsFromRealm() -> [FilmDataContainer]? {
        var result: [FilmDataContainer]?
        result = Array(realm.objects(FilmDataContainer.self))
        return result
    }
    
    func fetchAppUserFromRealm() -> AppUserDataContainer? {
        return realm.object(ofType: AppUserDataContainer.self, forPrimaryKey: 1)
    }
    
    func checkIsFavorite(filmId: String) -> Bool {
        let filmDataRealmobject = realm.objects(FilmDataContainer.self).filter("data.trackId == '\(filmId)'").first
        return filmDataRealmobject != nil
    }
    
    func deleteAllInRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error with all data deleting, \(error)")
        }
    }
}

