//
//  SignUpAController.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import UIKit
import SwiftyJSON
import SystemConfiguration

class SignUpAController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderPickerView: UIPickerView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    var isFirstNameEntered: Bool = false;
    var isLastNameEntered: Bool = false;
    var selectedGender: String!;
    
    var genderPickerData: [String] = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicator.hidesWhenStopped = true;
        
        firstNameField.delegate = self;
        lastNameField.delegate = self;
        self.genderPickerView.delegate = self
        self.genderPickerView.dataSource = self
        
        genderPickerData = ["Unspecified", "Male", "Female"];
        
        // Setting up logo image
        logoView.contentMode = .scaleAspectFit;
        logoView.backgroundColor = Utilities.THEME_BLACK_COLOR;
        logoView.image = UIImage(named: "logowoss");
        
        // Setting up all UITextField to look better
        firstNameField.layer.borderWidth = 0.9;
        firstNameField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        firstNameField.layer.cornerRadius = 5;
        firstNameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        lastNameField.layer.borderWidth = 0.9;
        lastNameField.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        lastNameField.layer.cornerRadius = 5;
        lastNameField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        
        // Setting up Next (signup) button
        nextButton.layer.cornerRadius = 5;
        nextButton.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        nextButton.layer.borderWidth = 1;
        nextButton.layer.borderColor = Utilities.THEME_RED_COLOR.cgColor;
        let nextButtonTitle = NSMutableAttributedString(string:"");
        let titleAttributedString = NSAttributedString(string: "Next", attributes: [NSForegroundColorAttributeName: UIColor.white]);
        nextButtonTitle.append(titleAttributedString);
        nextButton.setAttributedTitle(nextButtonTitle, for: .normal);
        
        // Setting up Log in button
        let backButtonTitle = NSMutableAttributedString(string:"");
        let subTitleAttributedStringA = NSAttributedString(string: "Have an account? ", attributes: [NSForegroundColorAttributeName: UIColor.darkGray]);
        let subTitleAttributedStringB = NSAttributedString(string: "Log in", attributes: [NSForegroundColorAttributeName: Utilities.THEME_RED_COLOR]);
        backButtonTitle.append(subTitleAttributedStringA);
        backButtonTitle.append(subTitleAttributedStringB);
        backButton.setAttributedTitle(backButtonTitle, for: .normal);
        
        // Looks for single or multiple taps and ends editting if found
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)));
        tap.cancelsTouchesInView = false;
        view.addGestureRecognizer(tap);
        
        Utilities.disableButton(button: nextButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     * Returns the number of columns in the genderPickerView
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /*
     * Returns the number of rows in the genderPickerView
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
    /*
     * Returns the data for the passed row in the genderPickerView
     */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = UIFont(name: "SanFranciscoText-Light", size: 17)
        
        label.text = genderPickerData[row]
        
        return label
    }

    /*
     * Captures the selection from genderPickerView
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = self.genderPickerData[row];
    }
    
    /*
     * backButton listener
     * Performs a segue to Login.storyboard when backButton
     */
    @IBAction func onBackButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    /*
     * nextButton button listener
     * Sets firstName, lastName to User.sharedInstance,
     * Sets gender to UserProfileSelf.sharedInstance
     * and performs segue to SignUpController.storyboard
     */
    @IBAction func onNextButtonPressed(_ sender: Any) {
        // showActivityIndicator();
        User.sharedInstance.setFirstName(firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines));
        User.sharedInstance.setLastName(lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines));
        // hideActivityIndicator();
        performSegue(withIdentifier: "signup", sender: nil)
    }
    
    /*
     * firstNameField onChange listener
     * Disables the nextButton if firstName or lastName not entered
     */
    @IBAction func onFirstNameFieldChanged(_ sender: Any) {
        if (firstNameField.text!.characters.count >= 1) { isFirstNameEntered = true; }
        else { isFirstNameEntered = false; }
        if(isFirstNameEntered && isLastNameEntered) { Utilities.enableButton(button: nextButton) }
        else { Utilities.disableButton(button: nextButton); }
    }
    
    /*
     * lastNameField onChange listener
     * Disables the nextButton if firstName or lastName not entered
     */
    @IBAction func onLastNameFieldChanged(_ sender: Any) {
        if (lastNameField.text!.characters.count >= 1) { isLastNameEntered = true; }
        else { isLastNameEntered = false; }
        if(isFirstNameEntered && isLastNameEntered) { Utilities.enableButton(button: nextButton) }
        else { Utilities.disableButton(button: nextButton); }
    }
    
    
    /*
     * Displays activityIndicator
     */
    func showActivityIndicator() {
        nextButton.setAttributedTitle(NSMutableAttributedString(string:""), for: .normal);
        activityIndicator.startAnimating();
    }
    
    /*
     * Hides activityIndicator
     */
    func hideActivityIndicator() {
        activityIndicator.stopAnimating();
        let attributedString = NSMutableAttributedString(string:"");
        let attsub = NSAttributedString(string: "Next", attributes: [NSForegroundColorAttributeName: UIColor.white]);
        attributedString.append(attsub);
        nextButton.setAttributedTitle(attributedString, for: .normal);
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
