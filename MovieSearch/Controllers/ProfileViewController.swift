//
//  ProfileViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 29.03.2023.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    @IBOutlet private weak var logOutView: UIView!
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var firstNameLabel: UILabel!
    @IBOutlet private weak var lastNameLabel: UILabel!
    
    private let realmManager = RealmManager()
    
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
            realmManager.deleteAllInRealm()
            navigateToWelcome()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            navigateToWelcome()
        }
    }
    
    func navigateToWelcome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func loadAppUserFromRealm() {
        appUser = realmManager.fetchAppUserFromRealm()
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
