//
//  Product.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Product: Equatable {
    
    private var id: Int;
    private var name: String;
    private var description: String;
    private var price: Float;
    private var barcode: String;
    private var quantity: Int;
    private var company_id: Int;
    private var company_name: String;
    
    // Singleton constructor
    public init() {
        id = -1;
        name = ""
        description = ""
        price = 0.0
        barcode = ""
        quantity = 0
        company_id = -1
        company_name = ""
    }
    
    public func setName(_ name: String) {
        self.name = name;
    }
    
    public func getName() -> String {
        return self.name;
    }
    
    public func setDescription(_ desc: String) {
        self.description = desc;
    }
    
    public func getDescription() -> String {
        return self.description
    }
    
    public func setBarcode(_ bc: String) {
        self.barcode = bc;
    }
    
    public func getBarcode() -> String {
        return self.barcode
    }
    
    public func setPrice(_ pr: Float) {
        self.price = pr;
    }
    
    public func getPrice() -> Float {
        return self.price;
    }
    
    public func setId(_ id: Int) {
        self.id = id;
    }
    
    public func getId() -> Int {
        return self.id;
    }
    
    public func setQuantity(_ q: Int) {
        self.quantity = q;
    }
    
    public func getQuantity() -> Int {
        return self.quantity
    }
    
    public func setCompanyId(_ i: Int) {
        self.company_id = i;
    }
    
    public func getCompanyId() -> Int {
        return self.company_id
    }
    
    public func setCompanyName(_ n: String) {
        self.name = n;
    }
    
    public func getCompanyName() -> String {
        return self.name;
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id;
    }
}
