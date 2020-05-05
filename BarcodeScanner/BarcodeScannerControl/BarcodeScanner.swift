//
//  BarcodeScanner.swift
//  BarcodeScanner
//
//  Created by Ahmed Abdelkarim on 1/29/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit
import AVFoundation

class BarcodeScanner: UIView, AVCaptureMetadataOutputObjectsDelegate {
    //MARK: - Variables
    /// Gets the current scanning state of barcode scanner.
    var isScanning:Bool {
        get {
            return captureSession != nil && captureSession!.isRunning
        }
    }
    
    /// The camera to use for scanning.
    var camera:ScannerCamera = .backCamera {
        didSet {
            updateScanningCamera()
        }
    }
    
    /// Types of barcode that the scanner will try to find during scanning. Note that the number of types affects performance of scanner, so for best possible performance support the required types only.
    var supportedTypes:[AVMetadataObject.ObjectType] = [.qr] {
        didSet {
            initControl()
            setupPreviewLayer()
        }
    }
    
    /// Whether to vibrate the device when a code is detected, or not.
    var vibrateWhenCodeDetected:Bool = true
    
    /// The delegate object of BarcodeScanner control.
    var delegate:BarcodeScannerDelegate?
    
    
    //MARK: - Local Variables
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    
    //MARK: - Lifecycle
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
        
        if(previewLayer != nil) {
            previewLayer.frame = self.layer.bounds
        }
    }
    
    
    //MARK: - Functions
    public func startScanning() {
        captureSession.startRunning()
        self.layer.addSublayer(previewLayer)
    }
    
    public func stopScanning() {
        captureSession.stopRunning()
        self.layer.sublayers?.removeAll()
    }
    
    
    //MARK: - Local Functions
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
            metadataOutput.metadataObjectTypes = supportedTypes
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
        previewLayer.videoGravity = .resizeAspectFill
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
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
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
