//
//  LogInViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class LogInViewController: UIViewController {
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    
    @IBOutlet private weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var logInButton: UIButton!
    
    private let realmManager = RealmManager()
    
    private var appUser: AppUserDataContainer?
    private var errorMessage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewElements()
        realmManager.deleteAllInRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: -- preparing for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.logInToNewUserData {
            if let destinationVC = segue.destination as? NewUserDataViewController {
                destinationVC.setAppUser(appUser, errorMessage: errorMessage)
            }
        }
    }
}


//MARK: - @IBActions


private extension LogInViewController {
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard let safeUserEmail = emailTextfield.text,
              let safeUserPassword = passwordTextfield.text else { return }

        activateScreenWaitingMode()

        Auth.auth().signIn(withEmail: safeUserEmail, password: safeUserPassword) {
            [weak self] authResult, error in
            if let safeError = error {
                print(safeError)

                DispatchQueue.main.async {
                    self?.failedToLogIn(withMessage: safeError.localizedDescription)
                }
            } else {
                self?.checkIsUserDataExists()
            }
        }
    }
}


//MARK: - Private methods


private extension LogInViewController {
    //MARK: -- user data checking
    func checkIsUserDataExists() {
        guard let safeCurrentUserId = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async {
                self.failedToLogIn(withMessage: "Try again")
            }
            return
        }
        
        Firestore.firestore().collection(K.FStore.usersCollection).document(safeCurrentUserId).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                do {
                    let chatUserData = try document.data(as: AppUserData.self)
                    
                    let defaultAvatarData = UIImage.defaultAvatar?.pngData()
                    self?.appUser = AppUserDataContainer(data: chatUserData, avatar: defaultAvatarData)
                    
                    self?.downloadAvatar(with: chatUserData.avatarURL)
                }
                catch {
                    DispatchQueue.main.async {
                        self?.failedToLogIn(withMessage: "Try again")
                    }
                    return
                }
            } else {
                self?.errorMessage = "Your user data doesn't exist. Set it please."

                let appUserDefaultData = AppUserData(userId: K.Case.emptyString, userEmail: K.Case.emptyString, firstName: K.Case.emptyString, lastName: K.Case.emptyString, avatarURL: K.Case.emptyString)
                let defaultAvatarData = UIImage.defaultAvatar?.pngData()
                let defaultAppUser = AppUserDataContainer(data: appUserDefaultData, avatar: defaultAvatarData)
                
                self?.appUser = defaultAppUser

                DispatchQueue.main.async {
                    self?.navigateToNewUserData()
                }
            }
        }
    }
    
    func downloadAvatar(with url: String) {
        let ref = Storage.storage().reference(forURL: url)
        
        let megaByte = Int64(1024 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { [weak self] data, error in
            if let safeError = error {
                print(safeError)
                
                self?.errorMessage = "Your avatar does not exist. Set it or click \"Continue\" to leave the default one."
                
                DispatchQueue.main.async {
                    self?.navigateToNewUserData()
                }
            } else {
                guard let safeAvatarData = data,
                      let safeAppUser = self?.appUser else {
                    DispatchQueue.main.async {
                        self?.failedToLogIn(withMessage: "Try again")
                    }
                    return
                }

                safeAppUser.avatar = safeAvatarData
                self?.realmManager.saveAppUserToRealm(safeAppUser)

                self?.downloadFavoriteFilms()
            }
        }
    }
    
    
    func downloadFavoriteFilms() {
        guard let safeCurrentUserId = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection(safeCurrentUserId + K.FStore.favoriteFilms).getDocuments {
            [weak self] (querySnapshot, error) in
            if let safeError = error {
                print("Error load favorite films: \(safeError)")
            } else {
                guard let documents = querySnapshot?.documents else { return }
                
                for document in documents {
                    do {
                        let filmData = try document.data(as: FilmData.self)
                        self?.realmManager.saveFavoriteFilmDataToRealm(FilmDataContainer(data: filmData))
                    }
                    catch {
                        print("Casting from QueryDocumentSnapshot to FilmData was failed")
                        continue
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.navigateToMainScreens()
            }
        }
    }

    //MARK: -- others
    func activateScreenWaitingMode() {
        errorLabel.text = K.Case.emptyString
        view.isUserInteractionEnabled = false
        progressIndicator.startAnimating()
    }
    
    func failedToLogIn(withMessage message: String) {
        errorLabel.text = message
        view.isUserInteractionEnabled = true
        progressIndicator.stopAnimating()
    }
    
    func navigateToNewUserData() {
        performSegue(withIdentifier: K.Segue.logInToNewUserData, sender: self)
    }
    
    func navigateToMainScreens() {
        performSegue(withIdentifier: K.Segue.logInToMainScreens, sender: self)
    }
}


//MARK: - Set up methods


private extension LogInViewController {
    func customizeViewElements() {
        progressIndicator.hidesWhenStopped = true
    }
}

