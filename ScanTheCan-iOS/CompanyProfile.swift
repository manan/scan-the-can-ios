//
//  UserProfileOther.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation

class CompanyProfile: Equatable {
    
    static var sharedInstance: CompanyProfile = CompanyProfile()
    
    private var products: [Product];
    private var name: String;
    private var userPId: Int!;
    
    public init() {
        name = "";
        products = [Product]()
    }
    
    public func setName(_ name: String) {
        self.name = name;
    }
    
    public func getName() -> String {
        return self.name;
    }
    
    public func setUserPId(_ upid: Int) {
        self.userPId = upid;
    }
    
    public func getUserPId() -> Int {
        return self.userPId;
    }
    
    public func getProducts() -> [Product] {
        return self.products;
    }
    
    public func setReceipts(_ products: [Product]) {
        self.products = products;
    }
    
    public func addToReceipts(_ product: Product) {
        if !(self.products.contains(product)){
            self.products.append(product);
        }
    }
    
    public static func == (lhs: CompanyProfile, rhs: CompanyProfile) -> Bool {
        return lhs.userPId == rhs.userPId;
    }
    
}
