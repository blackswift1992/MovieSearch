//
//  ChatUser.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import UIKit
import RealmSwift

class AppUser: Object {
    @Persisted(primaryKey: true) var id = 1

    @Persisted var data: AppUserData?
    @Persisted var avatar: Data?
    
    convenience init(data: AppUserData, avatar: Data? = nil) {
        self.init()
        self.data = data
        self.avatar = avatar
    }
}
