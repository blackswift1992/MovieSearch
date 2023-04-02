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
    
    private var appUser: AppUserDataContainer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAppUserFromRealm()
        customizeViewElements()
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
        do {
            try Auth.auth().signOut()
            deleteAllAppUsersInRealm()
            navigateToWelcome()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            navigateToWelcome()
        }
    }
    
    func deleteAllAppUsersInRealm() {
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
        appUser = realm.object(ofType: AppUserDataContainer.self, forPrimaryKey: 1)
    }
}


//MARK: - Set up methods


private extension ProfileViewController {
    func customizeViewElements() {
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 0.5
        
        logOutView.layer.cornerRadius = 17
        
        if let safeAppUser = appUser,
           let safeAppUserData = safeAppUser.data,
           let safeAvatarData = safeAppUser.avatar {
            avatarImageView.image = UIImage(data: safeAvatarData)
            emailLabel.text = safeAppUserData.userEmail
            firstNameLabel.text = safeAppUserData.firstName
            lastNameLabel.text = safeAppUserData.lastName
        }
    }
}
