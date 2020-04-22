//
//  ShortcutItemHandler.swift
//  BarcodeScanner
//
//  Created by Ahmed Abdelkarim on 4/22/20.
//  Copyright © 2020 Ahmed Abdelkarim. All rights reserved.
//

import UIKit

class ShortcutItemHandler {
    public static var delegate:ShortcutItemHandlerDelegate?
    
    private static let scanQR = "ScanQR"
    private static let scanEAN13 = "ScanEAN13"
    
    static func handle(_ shortcutItem: UIApplicationShortcutItem) {
        switch shortcutItem.type {
        case scanQR:
            delegate?.scanQR()
            break
        case scanEAN13:
            delegate?.scanEAN13()
            break
        default:
            break
        }
    }
}

protocol ShortcutItemHandlerDelegate {
    func scanQR()
    func scanEAN13()
}
