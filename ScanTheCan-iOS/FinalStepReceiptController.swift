//
//  FinalStepReceiptController.swift
//  ScanTheCan-iOS
//
//  Created by Manan Mehta on 2017-03-26.
//  Copyright © 2017 mehtamanan. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreImage
import Alamofire
import SwiftyJSON

class FinalStepReceiptController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var cameraOverlayView: UIView!
    @IBOutlet weak var sendReceiptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var session: AVCaptureSession!;
    var previewLayer: AVCaptureVideoPreviewLayer!;
    
    var username: String!;

    override func viewDidLoad() {
        super.viewDidLoad()
        Utilities.disableButton(button: sendReceiptButton)
        username = ""
        
        logoView.contentMode = .scaleAspectFit;
        logoView.backgroundColor = UIColor.white;
        logoView.image = UIImage(named: "logowoss");
        
        sendReceiptButton.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        sendReceiptButton.layer.borderWidth = 1;
        sendReceiptButton.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        
        cancelButton.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        cancelButton.layer.borderWidth = 1;
        cancelButton.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        
        session = AVCaptureSession(); // Creating session object
        let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo); // Get default device for Video type inputs
        let videoInput: AVCaptureDeviceInput? // store video input
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice) // set videoInput to get input from device
        } catch {
            return
        }
        
        if (session.canAddInput(videoInput)) { // if session can handle video input
            session.addInput(videoInput); // then add it
        } else {
            scanningNotPossible()
        }
        
        // Create output object.
        let metadata = AVCaptureMetadataOutput() // get the output data here
        if (session.canAddOutput(metadata)){ // add it to session if can be added
            session.addOutput(metadata)
            metadata.setMetadataObjectsDelegate(self, queue: DispatchQueue.main) // Send captured data to the delegate object via a serial queue.
            metadata.metadataObjectTypes = [AVMetadataObjectTypeQRCode] // Set barcode type for which to scan: EAN-13.
        } else {
            scanningNotPossible()
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer.frame = cameraOverlayView.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        cameraOverlayView.layer.addSublayer(previewLayer);
        
        session.startRunning() // Begin the capture session.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (session?.isRunning == false) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (session?.isRunning == true) {
            session.stopRunning()
        }
    }
    
    func scanningNotPossible() {
        let alert = UIAlertController(title: "Can't Scan.", message: "Let's try a device equipped with a camera.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        session = nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        session.stopRunning()
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            barcodeDetected(code: readableObject.stringValue);
        }
    }
    @IBAction func sendReceiptPressed(_ sender: Any) {
        let url = Utilities.BASE_URL + "receipts/add/username=" + username + "/company=" + String(CompanyProfile.sharedInstance.getUserPId()) + "/";
        print(url)
        Alamofire.request(url,
                          method: .get,
                          headers: ["Authorization": "Token " + User.sharedInstance.getToken()])
        .responseJSON { responseData in
            if (responseData.result.value != nil) {
                let response = JSON(responseData.result.value!);
                print("Here1")
                let id = String(describing: response["id"])
                print("Here2")
                let bcs = Utilities.ListOfStringToCommaSeparatedString(User.ToSendBarcodes)
                print("Here3")
                let newurl = Utilities.BASE_URL + "receipts/addproducts/receipt=" + id + "/barcodes=" + bcs + "/";
                print(newurl)
                Alamofire.request(newurl,
                                  method: .get,
                                  headers: ["Authorization":"Token " + User.sharedInstance.getToken()])
                    .responseJSON { resData in
                        if (resData.result.value != nil) {
                            print(resData.result.value!)
                        }
                }
                let alert = UIAlertController(title: "Sent!", message: "The receipt was sent to the customer.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:  { action in
                    User.ToSendBarcodes = [String]();
                    self.dismiss(animated: true, completion: nil) }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func onCancelPressed(_ sender: Any) {
        User.ToSendBarcodes = [String]()
        dismiss(animated: true, completion: nil)
    }
    
    func barcodeDetected(code: String) {
        // Remove the spaces.
        let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // EAN or UPC?
        // Check for added "0" at beginning of code.
        
        let trimmedCodeString = "\(trimmedCode)"
        var trimmedCodeNoZero: String
        
        if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
            trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
            print(trimmedCodeNoZero)
            username = trimmedCodeNoZero
        } else {
            print(trimmedCodeString)
            username = trimmedCodeString
        }
        Utilities.enableButton(button: sendReceiptButton)
        session.stopRunning()
    }

}
