//
//  HomeController.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SystemConfiguration

class HomeAController: UIViewController {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var viewReceiptsButton: UIButton!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoView.contentMode = .scaleAspectFit;
        logoView.backgroundColor = UIColor.white;
        logoView.image = UIImage(named: "logowoss");
        
        if let img = createQRFromString(User.sharedInstance.getUsername()) {
            let transform = CGAffineTransform(scaleX: 5.0, y: 5.0)
            let output: CIImage? = img.applying(transform)
            let someImage = UIImage(ciImage: output!, scale: 1.0, orientation: UIImageOrientation.down)
            QRCodeImageView.image = someImage;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onViewResultsPressed(_ sender: Any) {
        performSegue(withIdentifier: "allreceipts", sender: nil)
    }
    
    func createQRFromString(_ str: String) -> CIImage? {
        let stringData = str.data(using: String.Encoding.utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(stringData, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        return filter?.outputImage
    }
}
