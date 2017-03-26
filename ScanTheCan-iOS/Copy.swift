//
//  Copy.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Copy: Equatable {
    
    private var name: String;
    private var description: String;
    private var price: Float;
    private var barcode: String;
    
    public init() {
        name = ""
        description = ""
        price = 0.0
        barcode = ""
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
    
    public static func == (lhs: Copy, rhs: Copy) -> Bool {
        return false
    }
}
