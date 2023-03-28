//
//  ChatUserData.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatUserData: Codable {
    let userId: String
    let userEmail: String
    let firstName: String
    let lastName: String
    let avatarURL: String
    let userRGBColor: String
}
