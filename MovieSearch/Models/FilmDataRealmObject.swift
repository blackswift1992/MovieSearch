//
//  FilmDataRealmObject.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 01.04.2023.
//

import Foundation
import RealmSwift


class FilmDataRealmObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var data: FilmData?
    
    convenience init(data: FilmData) {
        self.init()
        self.data = data
    }
}
