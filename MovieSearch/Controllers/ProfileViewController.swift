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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewElements()
        
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
        navigateToWelcome() //видалити в майбутньому - тестовий режим
        
//        do {
//            try Auth.auth().signOut()
//            navigateToWelcome()
//        } catch let signOutError as NSError {
//            print("Error signing out: %@", signOutError)
//            navigateToWelcome()
//        }
    }
    
    func navigateToWelcome() {
        navigationController?.popToRootViewController(animated: true)
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
