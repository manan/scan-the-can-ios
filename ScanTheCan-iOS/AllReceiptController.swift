//
//  AllReceiptController.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

class ReceiptCell: UITableViewCell {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
}

class AllReceiptController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImg.contentMode = .scaleAspectFit;
        logoImg.backgroundColor = UIColor.white;
        logoImg.image = UIImage(named: "logowoss");
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewQRCodePressed(_ sender: Any) {
        performSegue(withIdentifier: "codeview", sender: nil)
    }
    
    @IBAction func refreshData(_ sender: Any) {
        Alamofire.request(Utilities.BASE_URL + Utilities.FETCH_SELF_PROFILE_DETAILS,
                          method: .get,
                          headers: ["Content-Type":"application/json", "Authorization":"Token " + User.sharedInstance.getToken()])
            .responseJSON { responseData in
                if (responseData.result.value != nil){
                    let response = JSON(responseData.result.value!).dictionaryValue;
                    User.sharedInstance.setUserId(response[Utilities.USERPROFILE_USER]!.int!);
                    User.sharedInstance.setFirstName(response[Utilities.USERPROFILE_FIRST_NAME]!.string!);
                    User.sharedInstance.setLastName(response[Utilities.USERPROFILE_LAST_NAME]!.string!);
                    let recs = response[Utilities.USERPROFILE_RECEIPTS]!.array!
                    var reces = [Receipt]()
                    for rec in recs {
                        let temp = Receipt()
                        var prods = [Copy]()
                        let ps = rec["products"].array!
                        for p in ps {
                            let c = Copy()
                            c.setName(p["name"].string!)
                            c.setPrice(p["price"].floatValue)
                            c.setDescription(p["description"].string!)
                            prods.append(c)
                        }
                        temp.setProducts(prods)
                        temp.setDate(rec["date"].string!)
                        temp.setCompanyName(rec["company_name"].string!)
                        reces.append(temp)
                    }
                    UserProfileSelf.sharedInstance.setUserPId(response[Utilities.USERPROFILE_ID]!.int!);
                    UserProfileSelf.sharedInstance.setReceipts(reces)
                    print(UserProfileSelf.sharedInstance.getReceipts().count)
                    DispatchQueue.main.async { self.tableView.reloadData() }
                }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserProfileSelf.sharedInstance.getReceipts().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ReceiptCell
        cell.firstLabel?.text = UserProfileSelf.sharedInstance.getReceipts()[indexPath.row].getCompanyName()
        cell.secondLabel?.text = UserProfileSelf.sharedInstance.getReceipts()[indexPath.row].getDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserProfileSelf.selectedReceipt = UserProfileSelf.sharedInstance.getReceipts()[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
    }
}

