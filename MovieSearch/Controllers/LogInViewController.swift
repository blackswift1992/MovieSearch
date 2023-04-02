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
import RealmSwift

class LogInViewController: UIViewController {
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    
    @IBOutlet private weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var logInButton: UIButton!
    
    private let realm = try! Realm()
    
    private var appUser: AppUser?
    private var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewElements()
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
                    
                    self?.appUser = AppUser(data: chatUserData, avatar: defaultAvatarData)
                    
                    //В ChatUser додати клас FavoriteFilms
                    //Витягнути з Firebase дані про favorite films і записати їх в об'єкт FavoriteFilms об'єкта chatSender і вже після цього викликати метод
                    //self?.downloadAvatar(with: chatUserData.avatarURL)
                    
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
                
                //Юзер залогінився, але його дані не існують
                //Юзера перекидують в NewUserDataViewController де зобов'язують юзера вказати необхідні дані. На цьому етапі при переході в NewUserDataViewController в якості об'єкта appSender-а передається nil
                //Хоча щоб не порушувати логіку, краще передати об'єкт appSender тільки з всіма дефолтними даними
                //Тут в майбутньому треба перевірити чи може краще передати nil?
                let appUserDefaultData = AppUserData(userId: K.Case.emptyString, userEmail: K.Case.emptyString, firstName: K.Case.emptyString, lastName: K.Case.emptyString, avatarURL: K.Case.emptyString)
                
                let defaultAvatarData = UIImage.defaultAvatar?.pngData()

                let defaultAppUser = AppUser(data: appUserDefaultData, avatar: defaultAvatarData)
                
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
                
                //На цьому етапі система визначила що у юзера є його дані АЛЕ НЕМАЄ АВАТАРКИ
                //Дані юзера і ДЕФОЛТНА АВАТАРКА записані в об'єкт appUser
                //Далі робиться переход в NewUserDataViewController і при переході передається об'єкт appUser, який вже буде оброблятися в самому NewUserDataViewController-і
                DispatchQueue.main.async {
                    self?.navigateToNewUserData()
                }
            } else {
                guard let safeAvatarData = data else {
                    DispatchQueue.main.async {
                        self?.failedToLogIn(withMessage: "Try again")
                    }
                    return
                }
                
                //На цьому етапі система визначила що у юзера є і його дані і його аватарка
                //Дані і аватарка юзера записані в об'єкт chatSender
                //І тут потрібно перед перeходом до MainScreens зберегти об'єкт appUser в Realm, щоб потім вже знаходячись в вкладці Профіль витягнути дані і аватар юзера з Realm-a і відобразити на екрані.
                self?.appUser?.avatar = safeAvatarData
                
                if let appUser = self?.appUser {
                    self?.saveAppUserToRealm(appUser)
                }
                
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
                        self?.saveFavoriteFilmDataToRealm(FilmDataRealmObject(data: filmData))
                    }
                    catch {
                        print("Retrieving FilmData from Firestore was failed")
                        continue
                    }
                }
            }
            
            DispatchQueue.main.async {
                self?.navigateToMainScreens()
            }
        }
    }
        
    //MARK: -- realm methods
    func saveAppUserToRealm(_ appUser: AppUser) {
        do {
            try realm.write {
                realm.add(appUser, update: .modified)
            }
        } catch {
            print("Error with appUser saving, \(error)")
        }
    }
    
    func saveFavoriteFilmDataToRealm(_ film: FilmDataRealmObject) {
        do {
            try realm.write {
                realm.add(film, update: .modified)
            }
        } catch {
            print("Error with appUser saving, \(error)")
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

