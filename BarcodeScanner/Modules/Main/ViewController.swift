//
//  ViewController.swift
//  BarcodeScanner
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

//TODO: add UI to change vibration enabled/disabled
//TODO: Quick action to share, and any other useful action

class ViewController: UIViewController, BarcodeScannerDelegate, ShortcutItemHandlerDelegate {
    //MARK: - Outlets
    @IBOutlet weak var barcodeScanner: BarcodeScanner!
    @IBOutlet weak var scanButtonView: UIView!
    @IBOutlet weak var scanButton: UIButton!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateScanButtonState()
        
        barcodeScanner.supportedTypes = [.qr, .ean13]
        barcodeScanner.delegate = self
        
        ShortcutItemHandler.delegate = self
        
        print("isScanning: \(barcodeScanner.isScanning)")
    }
    
    
    //MARK: - Functions
    func updateScanButtonState() {
        if(barcodeScanner.isScanning) {
            scanButton.setTitle("Stop", for: .normal)
            scanButtonView.layer.borderColor = UIColor.systemRed.cgColor
            scanButton.backgroundColor = .red
        }
        else {
            scanButton.setTitle("Scan", for: .normal)
            scanButtonView.layer.borderColor = UIColor.systemGreen.cgColor
            scanButton.backgroundColor = .green
        }
    }
    
    func displayDetectedCode(code: String) {
        let alert = UIAlertController(title: "Detected Code", message: code, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func scanBarcodeWithType(_ type:AVMetadataObject.ObjectType) {
        if(self.presentedViewController as? UIAlertController != nil) {
            self.dismiss(animated: true, completion: nil)
        }
        
        barcodeScanner.stopScanning()
        barcodeScanner.supportedTypes = [type]
        barcodeScanner.startScanning()
        updateScanButtonState()
    }
    
    
    //MARK: - Actions
    @IBAction func scanButtonClick(_ sender: Any) {
        if(barcodeScanner.isScanning) {
            barcodeScanner.stopScanning()
        }
        else {
            barcodeScanner.startScanning()
        }
        
        updateScanButtonState()
        
        print("isScanning: \(barcodeScanner.isScanning)")
    }
    
    @IBAction func changeCameraButtonClick(_ sender: Any) {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        
        if(barcodeScanner.camera == .backCamera) {
            barcodeScanner.camera = .frontCamera
        }
        else {
            barcodeScanner.camera = .backCamera
        }
    }
    
    
    //MARK: - BarcodeScannerDelegate
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String) {
        print("detected code: \(code)")
        print("isScanning: \(barcodeScanner.isScanning)")
        
        updateScanButtonState()
        
        displayDetectedCode(code: code)
    }
    
    func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner) {
        print("loaded but failed to detect code")
        
        updateScanButtonState()
    }
    
    func barcodeScannerFailedToLoad(scanner: BarcodeScanner) {
        print("failed to load")
        
        updateScanButtonState()
    }
    
    //MARK: - ShortcutItemHandlerDelegate
    
    //TODO: present scanner modally to maintain selected barcode types and make scanning more flexible
    
    func scanQR() {
        scanBarcodeWithType(.qr)
    }
    
    func scanEAN13() {
        scanBarcodeWithType(.ean13)
    }
}
