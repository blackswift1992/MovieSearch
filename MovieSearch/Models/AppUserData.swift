//
//  ChatUserData.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import Foundation
import FirebaseFirestoreSwift
import RealmSwift

class AppUserData: Object, Codable {
    @Persisted var userId: String
    @Persisted var userEmail: String
    @Persisted var firstName: String
    @Persisted var lastName: String
    @Persisted var avatarURL: String
    
    
    convenience init(userId: String, userEmail: String, firstName: String, lastName: String, avatarURL: String) {
        self.init()
        self.userId = userId
        self.userEmail = userEmail
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
    }
}
