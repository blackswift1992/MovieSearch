//
//  ChatUser.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import UIKit
import RealmSwift

//class ChatUser: Object {
//    let data: ChatUserData
//    var avatar: UIImage?
//
//    convenience init(data: ChatUserData, avatar: UIImage? = nil) {
//        self.init()
//        self.data = data
//        self.avatar = avatar
//    }
//}

class ChatUser: Object {
    @objc dynamic var data: ChatUserData?
    @objc dynamic var avatar: Data?
    
    convenience init(data: ChatUserData, avatar: Data? = nil) {
        self.init()
        self.data = data
        self.avatar = avatar
    }
}
