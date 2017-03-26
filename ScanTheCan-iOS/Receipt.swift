//
//  Receipt.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Receipt: Equatable {
    
    private var id: Int;
    private var owner: Int;
    private var username: String;
    private var date: String;
    private var products: [Copy];
    private var company_id: Int;
    private var company_name: String;
    
    // Singleton constructor
    public init() {
        id = -1
        owner = -1
        username = ""
        date = "1900-01-01"
        products = [Copy]()
        company_id = -1
        company_name = ""
    }
    
    public func setUsername(_ name: String) {
        self.username = name;
    }
    
    public func getName() -> String {
        return self.username;
    }
    
    public func setDate(_ da: String) {
        self.date = da;
    }
    
    public func getDate() -> String {
        return self.date
    }
    
    public func setProducts(_ products: [Copy]) {
        self.products = products;
    }
    
    public func getProducts() -> [Copy] {
        return self.products
    }
    
    public func setCompanyId(_ i: Int) {
        self.company_id = i;
    }
    
    public func getCompanyId() -> Int{
        return self.company_id;
    }
    
    public func setCompanyName(_ n: String) {
        self.company_name = n;
    }
    
    public func getCompanyName() -> String {
        return self.company_name
    }
    
    public static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs.id == rhs.id;
    }
}
