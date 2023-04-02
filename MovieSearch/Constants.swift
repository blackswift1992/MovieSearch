//
//  Constants.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

struct K {
    static let appName = "MovieSearch🔎"
    
    
    struct Segue {
        static let signUpToNewUserData = "SignUpToNewUserData"
        static let logInToNewUserData = "LogInToNewUserData"
        static let logInToMainScreens = "LogInToMainScreens"
        static let newUserDataToMainScreens = "NewUserDataToMainScreens"
        static let mainToFilmInfo = "MainToFilmInfo"
    }

    
    struct FStore {
        static let usersCollection = "users"
        static let avatarsCollection = "avatars"
        static let favoriteFilms = "favoriteFilms"
    }


    struct TableCell {
        static let filmNibIdentifier = "FilmCell"
        static let filmNibName = "FilmTableViewCell"
    }

    
    struct Image {
        static let jpegType = "image/jpeg"
    }

    
    struct Case {
        static let emptyString = ""
        static let unknownString = "unknown"
    }
}
