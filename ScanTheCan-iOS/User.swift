//
//  User.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class User {
    
    static var sharedInstance: User = User(username: "", password: "")
    static var ToSendBarcodes: [String] = [String]()
    
    private var username: String;
    private var password: String;
    private var firstName: String;
    private var lastName: String;
    private var email: String;
    private var userId: Int;
    private var token: String;
    
    private init(username: String, password: String) {
        self.username = username;
        self.password = password;
        self.firstName = "";
        self.lastName = "";
        self.email = "";
        self.token = "";
        userId = -1;
    }
    
    public func setFirstName(_ fn: String, _ onDatabase: Bool = false){
        self.firstName = fn;
    }
    
    public func setLastName(_ ln: String, _ onDatabase: Bool = false){
        self.lastName = ln;
    }
    
    public func setUsername(_ un: String, _ onDatabase: Bool = false){
        self.username = un;
    }
    
    public func setPassword(_ pw: String, _ onDatabase: Bool = false){
        self.password = pw;
    }
    
    public func setEmail(_ em: String, _ onDatabase: Bool = false){
        self.email = em;
    }
    
    public func setUserId(_ id: Int){
        self.userId = id;
    }
    
    public func setToken(_ tok: String){
        self.token = tok;
    }
    
    public func getUserId() -> Int {
        return self.userId;
    }
    
    public func getUsername() -> String {
        return self.username;
    }
    
    public func getFirstName() -> String! {
        return self.firstName;
    }
    
    public func getLastName() -> String! {
        return self.lastName;
    }
    
    public func getEmail() -> String! {
        return self.email;
    }
    
    public func getPassword() -> String! {
        return self.password;
    }
    
    public func getToken() -> String {
        return self.token;
    }
    
}
