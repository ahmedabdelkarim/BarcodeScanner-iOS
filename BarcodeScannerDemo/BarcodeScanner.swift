//
//  BarcodeScanner.swift
//  BarScannerDemo
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanner: UIView, AVCaptureMetadataOutputObjectsDelegate {
    //MARK: - Variables
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    var isScanning:Bool {
        get {
            return captureSession != nil && captureSession!.isRunning
        }
    }
    
    
    //MARK: - Properties
    var camera:ScannerCamera = .backCamera {
        didSet {
            updateScanningCamera()
        }
    }
    var vibrateWhenCodeDetected:Bool = true
    var delegate: BarcodeScannerDelegate?
    
    
    //MARK: - Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControl()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControl()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if(previewLayer == nil && captureSession != nil) {
            setupPreviewLayer()
        }
    }
    
    
    //MARK: - Functions
    func startScanning() {
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
            self.layer.addSublayer(previewLayer)
        }
    }
    
    public func stopScanning() {
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
            self.layer.sublayers?.removeAll()
        }
    }
    
    
    //MARK: - Private Functions
    private func initControl() {
        captureSession = AVCaptureSession()
        
        setupCaptureDeviceInput()
        
        if(captureSession == nil) {
            failedToLoad()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]//Can make this configurable to support other formats
        }
        else {
            failedToLoad()
            return
        }
    }
    
    private func setupCaptureDeviceInput() {
        var position = AVCaptureDevice.Position.front
        
        if(camera == .backCamera) {
            position = AVCaptureDevice.Position.back
        }
        
        let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position)
        
        if(videoCaptureDevice == nil) {
            failedToLoad()
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        }
        catch {
            failedToLoad()
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        }
        else {
            failedToLoad()
            return
        }
    }
    
    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.layer.bounds
        previewLayer.videoGravity = .resizeAspect
    }
    
    private func updateScanningCamera() {
        if(captureSession == nil) {
            return
        }
        
        for input in captureSession.inputs {
            captureSession.removeInput(input)
        }
        
        setupCaptureDeviceInput()
        previewLayer.session = captureSession
    }
    
    internal func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue
                else {
                    failedToDetectCode()
                    return
            }
            
            detectedCode(code: stringValue)
        }
    }
    
    private func detectedCode(code: String) {
        if(vibrateWhenCodeDetected) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
        delegate?.barcodeScannerDetectedCode(scanner: self, code: code)
    }
    
    private func failedToDetectCode() {
        captureSession = nil
        delegate?.barcodeScannerFailedToDetectCode(scanner: self)
    }
    
    private func failedToLoad() {
        captureSession = nil
        delegate?.barcodeScannerFailedToLoad(scanner: self)
    }
}

///The camera used to scan barcode.
enum ScannerCamera {
    case frontCamera
    case backCamera
}

protocol BarcodeScannerDelegate {
    ///The code was detected and extracted successfully.
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String)
    ///Scanner loaded, found encrypted image, but couldn't extract the string value.
    func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner)
    ///Couldn't load scanner.
    func barcodeScannerFailedToLoad(scanner: BarcodeScanner)
}
