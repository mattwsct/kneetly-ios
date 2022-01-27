//
//  AuthentificationManager.swift
//  KneetlyUserApp
//
//  Created by Matt Westcott on 07.12.16.
//  Copyright © 2016 Be It Safe Pty Ltd. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import ReactiveKit
 
public enum AuthError: CustomStringConvertible {
    case firebase(Error)
    case kneetlyLogin(RequestError<ApiErrorCategory<ApiLoginError>>)
    case kneetlyRegister(RequestError<ApiErrorCategory<ApiRegisterError>>)
    
    //TODO: add correct error handling
    public  var description: String {
        switch self {
        case .firebase(let e): return e.localizedDescription
        case .kneetlyLogin(let e): return e.message ?? "Unknown error"
        case .kneetlyRegister(let e): return e.message ?? "Unknown error"
        }
    }
}

public enum AuthentificationType {
    case email
    case facebook
    case google
}

public enum ScreenType {
    case unknown
    case credentials
    case dashboard
    case updateProfile
    case addVehicle
    case addCardInfo
}

public protocol AuthentificationManagerDelegate: class {
    func authentificationManager(_ manager: AuthentificationManager, didLoggedInWithUser user: FIRUser?)
    func authentificationManager(_ manager: AuthentificationManager, didFailedWithError error: AuthError)
    func authentificationManagerDidCanceled(_ manager: AuthentificationManager)
}

public class AuthentificationManager: NSObject {
    
    public static let sharedInstance = AuthentificationManager()
    
    public var authentificationType: AuthentificationType = .email
    
    private var requestSender: RequestSender!
    
    private var accessToken: String?
    
    public var isLoggedIn: Bool {
        //return FIRAuth.auth()?.currentUser != nil
        return accessToken != nil
    }
    
    public var newAccessTokenHandler: ((String)->())?
    
    public weak var delegate: AuthentificationManagerDelegate?
    
    public var loginRequestProvider: ((_ token: String) -> ApiRequest<LoginResult, ApiErrorCategory<ApiLoginError>>)?
    public var registerRequestProvider: ((_ token: String) -> ApiRequest<LoginResult, ApiErrorCategory<ApiRegisterError>>)?
    public var logoutRequestProvider: ((_ fcmToken: String?) -> ApiRequest<ApiObject, ApiErrorCategory<ApiDefaultError>>)!
    
    public var shouldUseAutoRegistration = true
    
    private override init() {
        
    }
    
    public func googleUser() -> GIDGoogleUser? {
        return GIDSignIn.sharedInstance().currentUser
    }
    
    public func currentEmail(completion: @escaping (_ email: String)->()){
        switch self.authentificationType {
        case .email:
            completion(FIRAuth.auth()?.currentUser?.email ?? "")
        case .google:
            completion(GIDSignIn.sharedInstance().currentUser.profile.email ?? "")
        case .facebook:
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email"])
                .start(completionHandler:  { (connection, result, error) in
                    if let result = result as? NSDictionary {
                         let email = result["email"] as? String
                        completion(email ?? "")
                    } else {
                        completion("")
                    }
                })
        }
    }
    
    public func configure(withRequestSender requestSender: RequestSender, completion: @escaping ()->()) {
        self.requestSender = requestSender
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, firebaseUser) in
            // TODO: Maybe need to logout here.
        })
        
        login(withRequestSender: requestSender) { (_) in
            completion()
        }
        
    }
    
    func login(withRequestSender requestSender: RequestSender, completion: @escaping (Error?)->()) {
        guard let user = FIRAuth.auth()?.currentUser else {
            completion(nil)
            return
        }
        
        user.getTokenForcingRefresh(true) { token, error in
            self.accessToken = token
            if let newToken = token {
                requestSender.sendRequest(apiRequest: self.loginRequest(withToken: newToken)) { (result) in
                    switch result {
                    case .success:
                        if let newAccessToken = result.value?.token {
                            self.accessToken = newAccessToken
                            self.newAccessTokenHandler?(newAccessToken)
                        }
                        completion(nil)
                    case .failure(let error):
                        if let error = error.originalError, error.isConnectionError() {
                            KneetlyAlert.show(errorMessage: error.localizedDescription ?? "",
                                              buttonTitle: R.string.localized.commonLoadDataErrorRetry(),
                                              buttonHandler: { [unowned self] in
                                                self.login(withRequestSender: requestSender, completion: completion)
                            })
                        }
                        else {
                            completion(nil)
                        }
                    }
                }
            }
            else if (error as! NSError).code == FIRAuthErrorCode.errorCodeNetworkError.rawValue {
                KneetlyAlert.show(errorMessage: error?.localizedDescription ?? "",
                                  buttonTitle: R.string.localized.commonLoadDataErrorRetry(),
                                  buttonHandler: { [unowned self] in
                                    self.login(withRequestSender: requestSender, completion: completion)
                })
            }
            else {
                completion(nil)
            }
        }
    }

    public func register(email: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            if let user = user {
                self.register(firebaseUser: user)
            }
            else {
                self.delegate?.authentificationManager(self, didFailedWithError: .firebase(error!))
            }
        }
    }
    
    public func login(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
            self.authentificationType = .email
            self.handleCompleteLogin(withUser: user, error: error as NSError?)
        }
    }
    
    public func loginWithGoogle(inViewController viewController: GIDSignInUIDelegate) {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = viewController
        GIDSignIn.sharedInstance().signIn()
    }
    
    public func loginWithFacebook(inViewController viewContoller: UIViewController) {
        self.getCredentialFromFasebook(inViewController: viewContoller, completion: { credential in
            FIRAuth.auth()?.signIn(with: credential) { user, error in
                self.authentificationType = .facebook
                self.handleCompleteLogin(withUser: user, error: error as NSError?)
            }
        })
    }
    
    func getCredentialFromFasebook(inViewController viewContoller: UIViewController, completion: @escaping (FIRAuthCredential)->()) {
        let manager = FBSDKLoginManager()
        manager.logOut()
        manager.loginBehavior = .web
        manager.logIn(withReadPermissions: ["public_profile"], from: viewContoller) { result, error in
            if let error = error {
                self.delegate?.authentificationManager(self, didFailedWithError: .firebase(error))
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    self.delegate?.authentificationManagerDidCanceled(self)
                    return
                }
                
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: result.token.tokenString)
                completion(credential)
            }
        }
    }
    
    public func logout(completion: @escaping (RequestError<ApiErrorCategory<ApiDefaultError>>?) -> Void) {
        requestSender.sendRequest(apiRequest: logoutRequestProvider(FIRInstanceID.instanceID().token())) { (result) in
            switch result {
            case .success:
                self.disconnectServices()
                completion(nil)
            case .failure(let error):
                if error.statusCode == ApiErrorCode.invalidAccessToken.rawValue {
                    self.disconnectServices()
                    completion(nil)
                }
                else {
                    completion(error)
                }
            }
        }
    }
    
    private func disconnectServices() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().disconnect()
    }
    
    public func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { error in
            completion(error)
        })
    }
    
    private func register(firebaseUser firUser: FIRUser) {
        firUser.getTokenForcingRefresh(true, completion: { (token, tokenUpdateError) in
            if let newToken = token {
                let config = AppConfig.API.self
                let request = self.registerRequestProvider!(newToken)
                self.requestSender.sendRequest(apiRequest: request, completion: { (result) in
                    switch result {
                    case .success(let loginResult):
                        self.newAccessTokenHandler?(loginResult.token)
                        self.delegate?.authentificationManager(self, didLoggedInWithUser: firUser)
                    case .failure(let error):
                        self.delegate?.authentificationManager(self, didFailedWithError: .kneetlyRegister(error))
                    }
                })
            }
            else {
                self.delegate?.authentificationManager(self, didFailedWithError: .firebase(tokenUpdateError!))
            }
        })
    }
    
    private func loginRequest(withToken token: String) -> ApiRequest<LoginResult, ApiErrorCategory<ApiLoginError>> {
        return loginRequestProvider!(token)
    }
    
    fileprivate func handleCompleteLogin(withUser user: FIRUser?, error: Error?) {
        if let error = error {
            self.delegate?.authentificationManager(self, didFailedWithError: .firebase(error))
        } else {
            user?.getTokenForcingRefresh(true, completion: { (token, tokenUpdateError) in
                if let newToken = token {
                    let request = self.loginRequest(withToken: newToken)
                    self.requestSender.sendRequest(apiRequest: request, completion: { (result) in
                        switch result {
                        case .success(let loginResult):
                            self.newAccessTokenHandler?(loginResult.token)
                            self.delegate?.authentificationManager(self, didLoggedInWithUser: user)
                        case .failure(let error):
                            if error.statusCode == ApiErrorCode.userNotFound.rawValue && self.shouldUseAutoRegistration {
                                self.register(firebaseUser: user!)
                            } else {
                                self.delegate?.authentificationManager(self, didFailedWithError: .kneetlyLogin(error))
                            }
                        }
                    })
                }
                else {
                    self.delegate?.authentificationManager(self, didFailedWithError: .firebase(tokenUpdateError!))
                }
            })
        }
    }
}

extension AuthentificationManager: GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.delegate?.authentificationManager(self, didFailedWithError: .firebase(error))
            return
        }
        
        if let authenication = user.authentication {
            let credential = FIRGoogleAuthProvider.credential(withIDToken: authenication.idToken, accessToken: authenication.accessToken)
            self.authentificationType = .google
            FIRAuth.auth()?.signIn(with: credential) { user, error in
                self.handleCompleteLogin(withUser: user, error: error)
            }
        }
    }
}

