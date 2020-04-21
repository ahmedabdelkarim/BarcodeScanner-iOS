//
//  BarcodeScannerDelegate.swift
//  BarcodeScanner
//
//  Created by Ahmed Abdelkarim on 4/21/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

/// The delegate of BarcodeScanner control.
protocol BarcodeScannerDelegate {
    ///The code was detected and extracted successfully.
    func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String)
    ///Scanner loaded, found encrypted image, but couldn't extract the string value.
    func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner)
    ///Couldn't load scanner.
    func barcodeScannerFailedToLoad(scanner: BarcodeScanner)
}
