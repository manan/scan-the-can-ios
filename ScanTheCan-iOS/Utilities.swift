//
//  Utilities.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

class Utilities {

    // Colors
    static let THEME_RED_COLOR: UIColor = UIColor(red: 205.0/255.0, green: 0, blue: 52.0/255.0, alpha: 1.0);
    static let THEME_GRAY_COLOR: UIColor = UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0);
    static let THEME_BLACK_COLOR: UIColor = UIColor(red: 35.0/255.0, green: 31.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    
    // URLS
    static let BASE_URL: String = "https://scanthecanapi.herokuapp.com/";
    static let ADD_PROFILE_USER: String = "profiles/users/add/";
    static let ADD_COMPANY_USER: String = "companies/users/add/";
    static let ADD_PROFILE: String = "profiles/add/";
    static let ADD_COMPANY: String = "companies/add/";
    static let FETCH_SELF_PROFILE_DETAILS: String = "profiles/self/";
    static let FETCH_SELF_COMPANY_DETAILS: String = "companies/self/";
    static let ADD_PRODUCT: String = "products/add/";
    static let ADD_RECEIPT: String = "receipts/add/";
    static let ADD_PRODUCTS_TO_RECEIPTS: String = "receipts/addproducts/receipt=";
    static let TOKEN_AUTH: String = "token-auth/";

    
    // API VARIABLES
    static let USERPROFILE_ID = "id"
    static let USERPROFILE_USER = "user"
    static let USERPROFILE_USERNAME = "username"
    static let USERPROFILE_FIRST_NAME = "first_name"
    static let USERPROFILE_LAST_NAME = "last_name"
    static let USERPROFILE_RECEIPTS = "receipts"
    
    static let COMPANY_ID = "id"
    static let COMPANY_NAME = "name"
    static let COMPANY_USER = "user"
    static let COMPANY_PRODUCTS = "products"
    
    static let USER_ID = "id"
    static let USER_USERNAME = "username"
    static let USER_FIRST_NAME = "first_name"
    static let USER_LAST_NAME = "last_name"
    static let USER_EMAIL = "email"
    static let USER_PASSWORD = "password"
    
    static let PRODUCT_ID = "id"
    static let PRODUCT_NAME = "name"
    static let PRODUCT_DESCRIPTION = "decription"
    static let PRODUCT_PRICE = "price"
    static let PRODUCT_BARCODE = "barcode"
    static let PRODUCT_QUANTITY = "id"
    static let PRODUCT_COMPANY = "company"
    static let PRODUCT_COMPANY_NAME = "company_name"
    
    static let COPY_ID = "id"
    static let COPY_NAME = "name"
    static let COPY_DESCRIPTION = "decription"
    static let COPY_PRICE = "price"
    static let COPY_BARCODE = "barcode"

    static let RECEIPT_ID = "id"
    static let RECEIPT_OWNER = "owner"
    static let RECEIPT_USERNAME = "username"
    static let RECEIPT_DATE = "date"
    static let RECEIPT_PRODUCTS = "products"
    static let RECEIPT_COMPANY = "company"
    static let RECEIPT_COMPANY_NAME = "company_name"
    
    
    // GENERAL CONSTANTS
    static let MINIMUM_PASSWORD_SIZE: Int = 6;
    static let MAXIMUM_PASSWORD_SIZE: Int = 15;
    
    
    /*
     Returns true if internet is available, false otherwise
     */
    static func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    static func ListToCommaSeparatedString(_ lst: [Int]) -> String {
        var result: String = "";
        for num in lst {
            result.append(String(num) + ",");
        }
        let indx = result.index(result.startIndex, offsetBy: result.characters.count - 1)
        result = result.substring(to: indx)
        return result
    }
    
    static func ListOfStringToCommaSeparatedString(_ lst: [String]) -> String {
        var result: String = "";
        for s in lst {
            result.append(s + ",");
        }
        let indx = result.index(result.startIndex, offsetBy: result.characters.count - 1)
        result = result.substring(to: indx)
        return result
    }
    
    /*
     * Prints all the variables in User.sharedInstance for debugging purposes
     */
    static func printUser(){
        print("Username: " + User.sharedInstance.getUsername());
        print("Password: " + User.sharedInstance.getPassword());
        print("firstName: " + User.sharedInstance.getFirstName());
        print("lastName: " + User.sharedInstance.getLastName());
        print("email: " + User.sharedInstance.getEmail());
        print("UserID: " + String(User.sharedInstance.getUserId()));
        print("token: " + User.sharedInstance.getToken());
    }
    
    /*
     Disables the button passed as argument
     */
    static func disableButton(button: UIButton){
        button.isEnabled = false;
        button.alpha = 0.5;
    }
    
    /*
     Enables the button passed as argument
     */
    static func enableButton(button: UIButton){
        button.isEnabled = true;
        button.alpha = 1;
    }
    
}
