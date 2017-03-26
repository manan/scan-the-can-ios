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
import AVFoundation
import CoreImage

class HomeBController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var cameraOverlayView: UIView!
    @IBOutlet weak var allProductsBut: UIButton!
    @IBOutlet weak var sendReceipBut: UIButton!
    
    var session: AVCaptureSession!;
    var previewLayer: AVCaptureVideoPreviewLayer!;
    
    var barcodesList: [String]!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Here")
        barcodesList = [String]()
        logoImg.contentMode = .scaleAspectFit;
        logoImg.backgroundColor = UIColor.white;
        logoImg.image = UIImage(named: "logowoss");
        
        allProductsBut.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        allProductsBut.layer.borderWidth = 1;
        allProductsBut.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        
        sendReceipBut.layer.backgroundColor = Utilities.THEME_RED_COLOR.cgColor;
        sendReceipBut.layer.borderWidth = 1;
        sendReceipBut.layer.borderColor = Utilities.THEME_GRAY_COLOR.cgColor;
        
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
            metadata.metadataObjectTypes = [AVMetadataObjectTypeEAN13Code] // Set barcode type for which to scan: EAN-13.
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
    @IBAction func onSendReceiptPressed(_ sender: Any) {
        print("Here")
        performSegue(withIdentifier: "finalstep", sender: nil)
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
    
    func barcodeDetected(code: String) {
        // Remove the spaces.
        let trimmedCode = code.trimmingCharacters(in: CharacterSet.whitespaces)
        
        // EAN or UPC?
        // Check for added "0" at beginning of code.
        let trimmedCodeString = "\(trimmedCode)"
        var trimmedCodeNoZero: String
        
        if trimmedCodeString.hasPrefix("0") && trimmedCodeString.characters.count > 1 {
            trimmedCodeNoZero = String(trimmedCodeString.characters.dropFirst())
            
            // Send the doctored UPC to DataService.searchAPI()
            print(trimmedCodeNoZero)
            barcodesList.append(trimmedCodeNoZero)
            User.ToSendBarcodes.append(trimmedCodeNoZero)
        } else {
            
            // Send the doctored EAN to DataService.searchAPI()
            print(trimmedCodeString)
            barcodesList.append(trimmedCodeString)
            User.ToSendBarcodes.append(trimmedCodeString)
        }
        session.startRunning()
    }

}
