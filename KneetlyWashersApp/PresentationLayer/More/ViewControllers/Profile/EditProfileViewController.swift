//
//  EditProfileViewController.swift
//  KneetlyWashersApp
//
//  Created by Matt Westcott on 07.02.17.
//  Copyright © 2017 Be It Safe Pty Ltd. All rights reserved.
//

import UIKit
import KneetlyCommon
import PhoneNumberKit
import AlamofireImage
import Fusuma
import IQKeyboardManagerSwift

class EditProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mobileTextField: PhoneNumberTextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var postcodeTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var profile: User!
    
    fileprivate var isAvatarChanged = false
    
    private lazy var fusumaVC: FusumaViewController = {
        let fusumaVC = FusumaViewController()
        fusumaVC.delegate = self
        return fusumaVC
    }()

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstNameTextField.text = profile.firstName
        lastNameTextField.text = profile.lastName
        emailTextField.text = profile.email
        mobileTextField.text = profile.phone
        addressTextField.text = profile.streetaddress
        suburbTextField.text = profile.suburb
        stateTextField.text = profile.state
        countryTextField.text = profile.country
        postcodeTextField.text = profile.postcode
        
        profile = profile.copy()
        
        if let avatarURL = URL(string: profile.avatar) {
            profileImageView.af_setImage(withURL: avatarURL)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func changeAvatar(_ sender: UITapGestureRecognizer) {
        present(fusumaVC, animated: true, completion: nil)
    }
    
    @IBAction func saveProfile() {
        IQKeyboardManager.sharedManager().resignFirstResponder()
        showProgress()
        
        var avatar: Data?
        if isAvatarChanged {
            avatar = UIImageJPEGRepresentation(profileImageView.image!, 1)
        }
        
        let request = ApiEndpoints.ProfileRequest.updateProfile(params: profile.dictionaryRepresentation(), avatar: avatar)
        AppDelegate.current().requestSender!.sendRequest(
            apiRequest: request,
            completion: { result in
                self.hideProgress()
                switch result {
                case .success(_):
                    NotificationCenter.default.post(name: NotificationCenterDefault.Profile.Updated, object: nil)
                    self.navigateBackAnimated()
                case .failure(let error):
                    KneetlyAlert.show(errorMessage: error.message ?? "")
                }
            }
        )
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let value = textField.text
        switch textField {
        case firstNameTextField: profile.firstName = value
        case lastNameTextField: profile.lastName = value
        case emailTextField: profile.email = value
        case mobileTextField: profile.phone = value
        case addressTextField: profile.streetaddress = value
        case suburbTextField: profile.suburb = value
        case stateTextField: profile.state = value
        case countryTextField: profile.country = value
        case postcodeTextField: profile.postcode = value
        default: break
        }
    }
}

extension EditProfileViewController: FusumaDelegate {
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        profileImageView.image = image
        isAvatarChanged = true
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
    
    }
    
    func fusumaCameraRollUnauthorized() {
        
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
    }
    
    func fusumaClosed() {
        
    }
}
