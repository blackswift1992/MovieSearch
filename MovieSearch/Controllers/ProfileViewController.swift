//
//  ProfileViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 29.03.2023.
//

import UIKit
import FirebaseAuth
import RealmSwift

class ProfileViewController: UIViewController {
    @IBOutlet private weak var logOutView: UIView!
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    
    private let realm = try! Realm()
    
    private var appUser: Results<ChatUser>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAppUserFromRealm()
        customizeViewElements()
        
        guard let safeAppUser = appUser?.first else { return }
        
        
        if let safeFirstName = safeAppUser.data?.firstName {
            print("first name exists!!!!!!!!!!!!!!!!!!!")
            firstNameLabel.text = safeFirstName
        }
        
        if let avatar = safeAppUser.avatar {
            print("avatar exists!!!!!!!!!!!!!!!!!!!")
            avatarImageView.image = UIImage(data: avatar)
        }
        
        //З Realm-а витягнути дані і аватарку юзера і відобразити їх на view
    }
}


//MARK: - @IBActions


private extension ProfileViewController {
    @IBAction func logOutButtonPressed(_ sender: UIButton) {
        logOut()
    }
}


//MARK: - Private methods


private extension ProfileViewController {
    func logOut() {
        deleteAllInRealm()
        navigateToWelcome() //видалити в майбутньому - тестовий режим
        
//        do {
//            try Auth.auth().signOut()
//            navigateToWelcome()
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//            navigateToWelcome()
//        }
    }
    
    func deleteAllInRealm() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error with appUser saving, \(error)")
        }
    }
    
    func navigateToWelcome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadAppUserFromRealm() {
        appUser = realm.objects(ChatUser.self)
    }
}


//MARK: - Set up methods


private extension ProfileViewController {
    func customizeViewElements() {
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 0.5
        
        logOutView.layer.cornerRadius = 17
    }
}
