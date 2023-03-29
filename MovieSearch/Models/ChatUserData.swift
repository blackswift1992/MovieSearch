//
//  ChatUserData.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import Foundation
import FirebaseFirestoreSwift


//struct ChatUserData: Codable {
//    let userId: String
//    let userEmail: String
//    let firstName: String
//    let lastName: String
//    let avatarURL: String
//}


import RealmSwift

class ChatUserData: Object, Codable {
    @objc dynamic var userId: String
    @objc dynamic var userEmail: String
    @objc dynamic var firstName: String
    @objc dynamic var lastName: String
    @objc dynamic var avatarURL: String
    
    convenience init(userId: String, userEmail: String, firstName: String, lastName: String, avatarURL: String) {
        self.init()
        self.userId = userId
        self.userEmail = userEmail
        self.firstName = firstName
        self.lastName = lastName
        self.avatarURL = avatarURL
    }
}
