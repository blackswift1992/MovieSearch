//
//  NewUserDataViewController.swift
//  MovieSearch
//
//  Created by Олексій Мороз on 28.03.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import RealmSwift

class NewUserDataViewController: UIViewController {
    @IBOutlet private weak var errorLabel: UILabel!
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var loadPhotoButton: UIButton!
    
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    
    @IBOutlet private weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var continueButton: UIButton!
    
    private let realm = try! Realm()
    
    private var appUser: AppUserDataContainer?
    private var errorMessage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViewElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}


//MARK: - Public methods


extension NewUserDataViewController {
    func setAppUser(_ appUser: AppUserDataContainer?, errorMessage: String?) {
        self.appUser = appUser
        self.errorMessage = errorMessage
    }
}


//MARK: - Protocols


extension NewUserDataViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        avatarImageView.image = image
    }
}


//MARK: - @IBActions


private extension NewUserDataViewController {
    @IBAction func loadPhotoButtonPressed(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        guard let safeFirstName = firstNameTextField.text?.trim() else { return }

        activateScreenWaitingMode()

        if !safeFirstName.isEmpty {
            uploadAvatar()
        } else {
            failedWithErrorMessage("Type your first name")
        }
    }
}


//MARK: - Private methods


private extension NewUserDataViewController {
    //MARK: -- avatar uploading
    func uploadAvatar() {
        guard let safeUserId = Auth.auth().currentUser?.uid,
              let safeUserEmail = Auth.auth().currentUser?.email,
              let safeFirstName = firstNameTextField.text?.trim(),
              let safeLastName = lastNameTextField.text?.trim(),
              let safeAvatarData = avatarImageView.image?.jpegData(compressionQuality: 0.02)
        else {
            failedWithErrorMessage("Try again")
            return
        }
        
        let avatarMetaData = StorageMetadata()
        avatarMetaData.contentType = K.Image.jpegType
        
        let avatarRef = Storage.storage().reference()
            .child(K.FStore.avatarsCollection)
            .child(safeUserId)
        
        avatarRef.putData(safeAvatarData, metadata: avatarMetaData) {
            [weak self] metaData, error in
            if metaData == nil {
                DispatchQueue.main.async {
                    self?.failedWithErrorMessage("Try again")
                }
                return
            }
            
            avatarRef.downloadURL { [weak self] url, error in
                guard let safeURL = url else {
                    DispatchQueue.main.async {
                        self?.failedWithErrorMessage("Try again")
                    }
                    return
                }
                
                let appUserData = AppUserData(userId: safeUserId, userEmail: safeUserEmail, firstName: safeFirstName, lastName: safeLastName, avatarURL: safeURL.absoluteString)
                
                self?.appUser = AppUserDataContainer(data: appUserData, avatar: safeAvatarData)
                
                self?.uploadAppUserData(appUserData)
            }
        }
    }
    
    //MARK: -- data uploading
    func uploadAppUserData(_ appUserData: AppUserData) {
        do {
            try Firestore.firestore().collection(K.FStore.usersCollection).document(appUserData.userId).setData(from: appUserData) { [weak self] error in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.failedWithErrorMessage("Try again")
                    } else {
                        if let appUser = self?.appUser {
                            self?.saveAppUserToRealm(appUser)
                        }

                        self?.navigateToMainScreens()
                    }
                }
            }
        } catch let error {
            print("Error writing AppUserData to Firestore: \(error)")
            
            DispatchQueue.main.async {
                self.failedWithErrorMessage("Try again")
            }
        }
    }
    
    //MARK: -- realm methods
    func saveAppUserToRealm(_ appUser: AppUserDataContainer) {
        do {
            try realm.write {
                realm.add(appUser, update: .modified)
            }
        } catch {
            print("Error with AppUserDataContainer saving to Realm, \(error)")
        }
    }
    
    //MARK: -- others
    func activateScreenWaitingMode() {
        errorLabel.text = K.Case.emptyString
        view.isUserInteractionEnabled = false
        progressIndicator.startAnimating()
    }
    
    func failedWithErrorMessage(_ message: String) {
        errorLabel.text = message
        view.isUserInteractionEnabled = true
        progressIndicator.stopAnimating()
    }
    
    func navigateToMainScreens() {
        performSegue(withIdentifier: K.Segue.newUserDataToMainScreens, sender: self)
    }
}


//MARK: - Set up methods


private extension NewUserDataViewController {
    func customizeViewElements() {
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.layer.borderWidth = 0.5
        
        loadPhotoButton.layer.cornerRadius = 16
        
        progressIndicator.hidesWhenStopped = true
        
        if let safeAppUser = appUser,
           let safeAppUserData = safeAppUser.data,
           let safeAvatarData = safeAppUser.avatar {
            firstNameTextField.text = safeAppUserData.firstName
            lastNameTextField.text = safeAppUserData.lastName
            avatarImageView.image = UIImage(data: safeAvatarData)
        }
        
        errorLabel.text = errorMessage
    }
}
