//
//  SignUpController.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    
    var isEmailEntered: Bool = false;
    var isPasswordEntered: Bool = false;
    var isUsernameEntered: Bool = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        activityIndicator.hidesWhenStopped = true;
        
        emailField.delegate = self;
        usernameField.delegate = self;
        passwordField.delegate = self;
        
        // Setting up logo image
        logoView.contentMode = .scaleAspectFit;
        logoView.backgroundColor = Utilities.THEME_BLACK_COLOR;
        logoView.image = UIImage(named: "logowoss");
        
        // Setting up all UITextField to look better
        emailField.layer.borderWidth = 0.9;
        emailField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        emailField.layer.cornerRadius = 5;
        emailField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        usernameField.layer.borderWidth = 0.9;
        usernameField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        usernameField.layer.cornerRadius = 5;
        usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        passwordField.layer.borderWidth = 0.9;
        passwordField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        passwordField.layer.cornerRadius = 5;
        passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // Setting up Sign up button
        signUpButton.layer.cornerRadius = 5;
        signUpButton.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        signUpButton.layer.borderWidth = 1;
        signUpButton.layer.borderColor = Utilities.THEME_RED_COLOR.cgColor;
        let titlestring = NSMutableAttributedString(string:"");
        let loginattr = NSAttributedString(string: "Sign up", attributes: [NSForegroundColorAttributeName: UIColor.white]);
        titlestring.append(loginattr);
        signUpButton.setAttributedTitle(titlestring, for: .normal);
        
        // Setting up Log in button
        let attributedString = NSMutableAttributedString(string:"");
        let attsuba = NSAttributedString(string: "Have an account? ", attributes: [NSForegroundColorAttributeName: UIColor.darkGray]);
        let attsubb = NSAttributedString(string: "Log in", attributes: [NSForegroundColorAttributeName: Utilities.THEME_RED_COLOR]);
        attributedString.append(attsuba);
        attributedString.append(attsubb);
        backToLoginButton.setAttributedTitle(attributedString, for: .normal);
        
        // Looks for single or multiple taps and ends editting if found
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)));
        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap);
        
        Utilities.disableButton(button: signUpButton);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * backToLoginButton listener
     * Performs a segue to Login.storyboard
     */
    @IBAction func onBackToLoginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    /*
     * SignUpButton listener
     * Checks for internet on device, if connected,
     * sets username, password and email to User.sharedInstance
     * and makes call to createAccount(_:)
     * If not, displays alert
     */
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
        showActivityIndicator();
        User.sharedInstance.setUsername(usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines));
        User.sharedInstance.setPassword(passwordField.text!);
        User.sharedInstance.setEmail(emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines));
        if (Utilities.isInternetAvailable()) {
            createAccount()
        } else {
            hideActivityIndicator();
            let alert = UIAlertController(title: "System offline",
                                          message: "The internet connection appears to be offline. Please connect to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /*
     * makes API call to UTILITIES.ADD_USER with post-data
     * On success, sets userId to User.sharedInstance,
     * calls tokenAuth(_:)
     * On failure, displays error message
     */
    func createAccount() {
//        Alamofire.request(Utilities.BASE_URL + Utilities.ADD_USER,
//                          method: .post,
//                          parameters: [Utilities.USER_USERNAME: User.sharedInstance.getUsername(),
//                                       Utilities.USER_PASSWORD: User.sharedInstance.getPassword(),
//                                       Utilities.USER_FIRST_NAME: User.sharedInstance.getFirstName(),
//                                       Utilities.USER_LAST_NAME: User.sharedInstance.getLastName(),
//                                       Utilities.USER_EMAIL: User.sharedInstance.getEmail()],
//                          encoding: JSONEncoding.default,
//                          headers: ["Content-Type":"application/json"])
//            .responseJSON { responseData in
//                self.hideActivityIndicator();
//                if (responseData.result.value != nil) {
//                    let swiftyJsonvar = JSON(responseData.result.value!).dictionaryValue;
//                    if (swiftyJsonvar[Utilities.USER_ID] != nil) {
//                        User.sharedInstance.setUserId(swiftyJsonvar[Utilities.USER_ID]!.int!);
//                        User.sharedInstance.setUsername(swiftyJsonvar[Utilities.USER_USERNAME]!.string!);
//                        User.sharedInstance.setEmail(swiftyJsonvar[Utilities.USER_EMAIL]!.string!);
//                        User.sharedInstance.setFirstName(swiftyJsonvar[Utilities.USER_FIRST_NAME]!.string!);
//                        User.sharedInstance.setLastName(swiftyJsonvar[Utilities.USER_LAST_NAME]!.string!);
//                        self.tokenAuthAndCreateProfile();
//                    } else if (swiftyJsonvar[Utilities.USER_USERNAME] != nil
//                        && swiftyJsonvar[Utilities.USER_USERNAME]!.array![0].string! == "A user with that username already exists.") {
//                        let alert = UIAlertController(title: "A user with that username already exists.",
//                                                      message: "",
//                                                      preferredStyle: UIAlertControllerStyle.alert);
//                        alert.addAction(UIAlertAction(title: "Try again",
//                                                      style: UIAlertActionStyle.default,
//                                                      handler: { action in self.usernameField.becomeFirstResponder(); }));
//                        self.present(alert, animated: true, completion: nil);
//                        
//                    } else if (swiftyJsonvar[Utilities.USER_EMAIL] != nil && swiftyJsonvar[Utilities.USER_EMAIL]!.array![0].string! == "Enter a valid email address.") {
//                        let alert = UIAlertController(title: "Please enter a valid email address.",
//                                                      message: "",
//                                                      preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default,
//                                                      handler: { action in self.emailField.becomeFirstResponder(); }));
//                        self.present(alert, animated: true, completion: nil);
//                    }
//                } else {
//                    let alert = UIAlertController(title: "Oops! Something went wrong.",
//                                                  message: "Please sign up again.",
//                                                  preferredStyle: UIAlertControllerStyle.alert);
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil);
//                }
//        }
    }
    
    /*
     * makes API call to Utilties.TOKEN_AUTH
     * On success,
     * sets token to User.sharedInstance and makes API call
     * to Utilities.ADD_PROFILE and on success, performs segue to
     * Home.storyboard and on failure, displays error message
     *
     */
    func tokenAuthAndCreateProfile() {
//        Alamofire.request(Utilities.BASE_URL + Utilities.TOKEN_AUTH,
//                          method: .post,
//                          parameters: [Utilities.USER_USERNAME: User.sharedInstance.getUsername(),
//                                       Utilities.USER_PASSWORD: User.sharedInstance.getPassword()],
//                          encoding: JSONEncoding.default,
//                          headers: ["Content-Type":"application/json"])
//        .responseJSON { responseData in
//            if (responseData.result.value != nil) {
//                let temp = JSON(responseData.result.value!).dictionaryValue;
//                if (temp["token"] != nil) {
//                    User.sharedInstance.setToken(temp["token"]!.string!);
//                    Alamofire.request(Utilities.BASE_URL + Utilities.ADD_PROFILE,
//                                      method: .post,
//                                      parameters: [Utilities.USERPROFILE_USER: User.sharedInstance.getUserId(),
//                                                   Utilities.USERPROFILE_BIO: UserProfileSelf.sharedInstance.getBio(),
//                                                   Utilities.USERPROFILE_BIRTH_DATE: UserProfileSelf.sharedInstance.getBirthDate(),
//                                                   Utilities.USERPROFILE_GENDER: UserProfileSelf.sharedInstance.getGender()],
//                                      encoding: JSONEncoding.default,
//                                      headers: ["Content-Type":"application/json",
//                                                "Authorization":"Token " + User.sharedInstance.getToken()])
//                    .responseJSON { responseData in
//                        if (responseData.result.value != nil) {
//                            self.performSegue(withIdentifier: "loggedin", sender: nil);
//                        } else {
//                            let alert = UIAlertController(title: "Oops! Something went wrong.",
//                                                          message: "Please sign up again.",
//                                                          preferredStyle: UIAlertControllerStyle.alert);
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil);
//                        }
//                    }
//                }
//            } else {
//                let alert = UIAlertController(title: "Oops! Something went wrong.",
//                                              message: "Please sign up again.",
//                                              preferredStyle: UIAlertControllerStyle.alert);
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil);
//            }
//        }
    }
    
    /*
     * emailField onChange listener
     * Disables the signup button if the emailfield or the usernamefield
     * is empty or if the passawordfield has less than 6 characters
     */
    @IBAction func onEmailFieldChanged(_ sender: Any) {
        if (emailField.text!.characters.count >= 1) { isEmailEntered = true;
        } else { isEmailEntered = false; }
        if(isEmailEntered && isPasswordEntered && isUsernameEntered) { Utilities.enableButton(button: signUpButton)
        } else { Utilities.disableButton(button: signUpButton); }
    }
    
    /*
     * usernameField onChange listener
     * Disables signUpButton if the emailfield or the usernamefield
     * is empty or if the passawordField has less than 6 characters
     */
    @IBAction func onUsernameFieldChanged(_ sender: Any) {
        if (usernameField.text!.characters.count >= 1) { isUsernameEntered = true;
        } else { isUsernameEntered = false; }
        if(isEmailEntered && isPasswordEntered && isUsernameEntered) { Utilities.enableButton(button: signUpButton);
        } else { Utilities.disableButton(button: signUpButton); }
    }
    
    /*
     * passwordfield onChange listener
     * Disables the signup button if the emailfield or the usernamefield
     * is empty or if the passawordfield has less than 6 characters
     */
    @IBAction func onPasswordFieldChanged(_ sender: Any) {
        if (passwordField.text!.characters.count >= 6 && passwordField.text!.characters.count <= 15) { isPasswordEntered = true;
        } else { isPasswordEntered = false; }
        if(isEmailEntered && isPasswordEntered && isUsernameEntered){ Utilities.enableButton(button: signUpButton);
        } else { Utilities.disableButton(button: signUpButton); }
    }
    
    /*
     * password onBeginEdit listener
     * Disables the signup button if the emailfield or the usernamefield
     * is empty or if the passawordfield has less than 6 characters
     */
    @IBAction func onPasswordFieldBeginEdit(_ sender: Any) {
        if (passwordField.text!.characters.count >= Utilities.MINIMUM_PASSWORD_SIZE && passwordField.text!.characters.count <= Utilities.MAXIMUM_PASSWORD_SIZE) {
            isPasswordEntered = true;
        }
        else { isPasswordEntered = false; }
        if(isEmailEntered && isPasswordEntered && isUsernameEntered) { Utilities.enableButton(button: signUpButton);
        } else { Utilities.disableButton(button: signUpButton); }
    }

    
    /*
     * Displays UIActivityIndicator on the login button
     */
    func showActivityIndicator() {
        signUpButton.setAttributedTitle(NSMutableAttributedString(string:""), for: .normal);
        activityIndicator.startAnimating();
    }

    /*
     * Hides the UIActivityIndicator
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating();
        let attributedString = NSMutableAttributedString(string:"");
        let attsub = NSAttributedString(string: "Sign up", attributes: [NSForegroundColorAttributeName: UIColor.white]);
        attributedString.append(attsub);
        signUpButton.setAttributedTitle(attributedString, for: .normal);
    }
    
    /*
     * Dismisses the keyboard when pressed return
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
     * Dismisses the keyboard from view when called
     */
    func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
