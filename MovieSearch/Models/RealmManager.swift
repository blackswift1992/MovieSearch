//
//  RealmManager.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 02.04.2023.
//

import UIKit
import RealmSwift

class RealmManager {
    static private let realm = try! Realm()
    
    private var favoriteFilms: Results<FilmDataContainer>?
}


//MARK: - Public methods


extension RealmManager {
    func fetchFavoriteFilmsFromRealm() -> Results<FilmDataContainer>? {
        return RealmManager.realm.objects(FilmDataContainer.self)
    }
    
    func fetchAppUserFromRealm() -> AppUserDataContainer? {
        return RealmManager.realm.object(ofType: AppUserDataContainer.self, forPrimaryKey: 1)
    }
    
    func saveAppUserToRealm(_ appUser: AppUserDataContainer) {
        do {
            try RealmManager.realm.write {
                RealmManager.realm.add(appUser, update: .modified)
            }
        } catch {
            print("Error with AppUserDataContainer saving to Realm, \(error)")
        }
    }
    
    func saveFavoriteFilmDataToRealm(_ film: FilmDataContainer) {
        do {
            try RealmManager.realm.write {
                RealmManager.realm.add(film, update: .modified)
            }
        } catch {
            print("Error with FilmDataContainer saving to Realm, \(error)")
        }
    }
    
    func saveFilmDataContainerToRealm(_ data: FilmDataContainer) -> Bool {
        do {
            try RealmManager.realm.write {
                RealmManager.realm.add(data, update: .modified)
            }
        } catch {
            print("Error with favorite film data saving to Realm, \(error)")
            return false
        }
        
        return true
    }
    
    func checkIsFavorite(filmId: String) -> Bool {
        let filmDataRealmobject = RealmManager.realm.objects(FilmDataContainer.self).filter("data.trackId == '\(filmId)'").first
        return filmDataRealmobject != nil
    }
    
    func deleteFavoriteFilmFromRealm(_ film: FilmDataContainer) {
        do {
            try RealmManager.realm.write {
                RealmManager.realm.delete(film)
            }
        } catch {
            print("Error with favorite film deleting, \(error)")
        }
    }
    
    func deleteAllInRealm() {
        do {
            try RealmManager.realm.write {
                RealmManager.realm.deleteAll()
            }
        } catch {
            print("Error with all data deleting, \(error)")
        }
    }
}

