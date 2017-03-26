//
//  LoginController.swift
//  themoviebook
//
//  Created by Manan Mehta on 2016-12-26.
//  Copyright © 2016 mehtamanan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

class LoginBController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var helpSignInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Delegating view for usernamefield and password field (to end edit on return)
        self.usernameField.delegate = self;
        self.passwordField.delegate = self;
        
        activityIndicator.hidesWhenStopped = true;
        
        // Setting up logo image
        logoView.contentMode = .scaleAspectFit;
        logoView.backgroundColor = UIColor.white;
        logoView.image = UIImage(named: "logowoss");
        
        // Setting up username/password field appearance
        usernameField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        usernameField.layer.cornerRadius = 5;
        usernameField.layer.borderWidth = 0.9;
        passwordField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        passwordField.layer.cornerRadius = 5;
        passwordField.layer.borderWidth = 0.9;
        
        // To start the text inside 10 units away from the left margin
        usernameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        passwordField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        
        // Setting up login button appearance
        loginButton.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        loginButton.layer.cornerRadius = 5;
        loginButton.layer.borderWidth = 1;
        loginButton.layer.borderColor = Utilities.THEME_RED_COLOR.cgColor;
        let logInButtonTitle = NSMutableAttributedString(string:"");
        let titleAttributedString = NSAttributedString(string: "Login", attributes: [NSForegroundColorAttributeName: UIColor.white]);
        logInButtonTitle.append(titleAttributedString);
        loginButton.setAttributedTitle(logInButtonTitle, for: .normal);
        Utilities.disableButton(button: loginButton);
        
        // Setting up helpsignin button
        helpSignInButton.setTitleColor(Utilities.THEME_RED_COLOR, for: .normal);
        
        // Setting up Sign up button
        let attributedString = NSMutableAttributedString(string:"");
        let sub_a = NSAttributedString(string: "Don't have an account? ", attributes: [NSForegroundColorAttributeName: UIColor.darkGray]);
        let sub_b = NSAttributedString(string: "Sign Up.", attributes: [NSForegroundColorAttributeName: Utilities.THEME_RED_COLOR]);
        attributedString.append(sub_a);
        attributedString.append(sub_b);
        signUpButton.setAttributedTitle(attributedString, for: .normal);
        
        // Looks for single or multiple taps and ends editting if found
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)));
        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     * PasswordField onChange listener
     * Enables the loginButton whenever usernameField
     * is not empty and passwordFieldd contains more than
     * 6 characters
     */
    @IBAction func onPasswordFieldChange(_ sender: Any) {
        if (((passwordField.text?.characters.count)! >= Utilities.MINIMUM_PASSWORD_SIZE) &&
            ((usernameField.text?.characters.count)! > 0)) {
            Utilities.enableButton(button: loginButton);
        } else {
         Utilities.disableButton(button: loginButton);
        }
    }
    
    /*
     * UsernameField onChange listener
     * Enables loginButton whenever usernameField
     * is not empty and passwordFieldd contains more than
     * 6 characters
     */
    @IBAction func onUsernameFieldChange(_ sender: Any) {
        if (((passwordField.text?.characters.count)! >= Utilities.MINIMUM_PASSWORD_SIZE) &&
            ((usernameField.text?.characters.count)! > 0)) {
            Utilities.enableButton(button: loginButton);
        } else {
            Utilities.disableButton(button: loginButton);
        }
    }
    
    @IBAction func onSignUpButtonPressed(_ sender: Any) {
        // self.performSegue(withIdentifier: "signup", sender: nil)
    }
    
    @IBAction func onUserLoginPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "userlogin", sender: nil)
    }
    
    /*
     * loginButton listener
     * Checks if internet is available on device, if connected,
     * assigns username, password to User.sharedInstance
     * and makes call to authenticate(_:)
     * If not, displays alert
     */
    @IBAction func onLoginButtonPressed(_ sender: Any) {
        showActivityIndicator();
        User.sharedInstance.setUsername(usernameField.text!.trimmingCharacters(in: .whitespacesAndNewlines));
        User.sharedInstance.setPassword(passwordField.text!);
        if (Utilities.isInternetAvailable()) {
            authenticate()
        } else {
            hideActivityIndicator();
            let alert = UIAlertController(title: "System offline", message: "The internet connection appears to be offline. Please connect to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    /*
     * Makes API call to Utilities.TOKEN_AUTH
     * If credentials match,
     * stores token in User.sharedInstance, makes a call to /users/fetchdetails/ and
     * stored firstname, lastname and email in User.sharedInstance and then,
     * performs segue to Home.storyboard
     * else, displays alert
     */
    func authenticate() {
        Alamofire.request(Utilities.BASE_URL + Utilities.TOKEN_AUTH,
                          method: .post,
                          parameters: [Utilities.USER_USERNAME: User.sharedInstance.getUsername(),
                                       Utilities.USER_PASSWORD: User.sharedInstance.getPassword()],
                          encoding: JSONEncoding.default,
                          headers: ["Content-Type":"application/json"])
            .responseJSON { responseData in
                self.hideActivityIndicator();
                if (responseData.result.value != nil) {
                    let response = JSON(responseData.result.value!).dictionaryValue;
                    if (response["token"] != nil) {
                        User.sharedInstance.setToken(response["token"]!.string!);
                        Alamofire.request(Utilities.BASE_URL + Utilities.FETCH_SELF_COMPANY_DETAILS,
                                          method: .get,
                                          headers: ["Content-Type":"application/json", "Authorization":"Token " + User.sharedInstance.getToken()])
                            .responseJSON { responseData in
                                if (responseData.result.value != nil){
                                    let response = JSON(responseData.result.value!).dictionaryValue;
                                    User.sharedInstance.setUserId(response[Utilities.COMPANY_USER]!.int!);
                                    CompanyProfile.sharedInstance.setUserPId(response[Utilities.COMPANY_ID]!.int!)
                                    // TODO
                                    print(response)
                                    self.performSegue(withIdentifier: "loggedin", sender: nil)
                                }
                            }
                    } else {
                        let alert = UIAlertController(title: "Incorrect credentials", message: "The credentials you entered were incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler:  { action in
                            self.passwordField.becomeFirstResponder(); }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
        }
    }
    
    /*
     * Displays UIActivityIndicator on the login button
     */
    func showActivityIndicator() {
        loginButton.setAttributedTitle(NSMutableAttributedString(string:""), for: .normal);
        activityIndicator.startAnimating();
    }
    
    /*
     * Hides the UIActivityIndicator
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating();
        let attributedString = NSMutableAttributedString(string:"");
        let sub = "Login";
        let attr = [NSForegroundColorAttributeName: UIColor.white];
        let attsub = NSAttributedString(string: sub, attributes: attr);
        attributedString.append(attsub);
        loginButton.setAttributedTitle(attributedString, for: .normal);
    }
    
    /*
     * Dismisses the keyboard on return
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*
     * Dismisses the keyboard from view
     */
    func dismissKeyboard(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

}

