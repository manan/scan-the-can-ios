//
//  UserProfileSelf.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserProfileSelf {
    
    static var sharedInstance: UserProfileSelf = UserProfileSelf();
    static var selectedReceipt: Receipt = Receipt();
    
    private var receipts: [Receipt];
    private var userPId: Int;
    
    // Singleton constructor
    private init() {
        receipts = [Receipt]();
        userPId = -1;
    }
    
    public func setUserPId(_ upid: Int) {
        self.userPId = upid;
    }
    
    public func getUserPId() -> Int {
        return self.userPId;
    }
    
    public func getReceipts() -> [Receipt] {
        return self.receipts;
    }
    
    public func setReceipts(_ receipts: [Receipt]) {
        self.receipts = receipts;
    }
    
    public func addToReceipts(_ receipt: Receipt) {
        if !(self.receipts.contains(receipt)){
            self.receipts.append(receipt);
        }
    }
   
    public func clearNewsFeed(){
        self.receipts.removeAll();
    }
}
