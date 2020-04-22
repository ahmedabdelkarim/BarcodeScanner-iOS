
# BarcodeScanner-iOS
BarcodeScanner is an iOS custom control written in Xcode 11.2 and Swift 5 for scanning barcode, with demo project showing features of the control.

**BarcodeScanner:**
* Written in Swift 5
* Scans QR code.
* Scans EAN-13 code.
* Supports scanning 10+ other barcode types.
* Front & back camera support
* Can change camera while scanning or stopped
* Delegates to handle detected code, and errors
* Can be easily reused

**How to use BarcodeScanner?**

    class ViewController: UIViewController, BarcodeScannerDelegate {
        //MARK: - Outlets
        @IBOutlet weak var barcodeScanner: BarcodeScanner!
        
        //MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            barcodeScanner.supportedTypes = [.qr, .ean13]
            barcodeScanner.delegate = self
        }
        
        //MARK: - Actions
        @IBAction func scanButtonClick(_ sender: Any) {
            if(barcodeScanner.isScanning) {
                barcodeScanner.stopScanning()
            }
            else {
                barcodeScanner.startScanning()
            }
        }
        
        @IBAction func changeCameraButtonClick(_ sender: Any) {
            if(barcodeScanner.camera == .backCamera) {
                barcodeScanner.camera = .frontCamera
            }
            else {
                barcodeScanner.camera = .backCamera
            }
        }
        
        //MARK: - Delegates
        func barcodeScannerDetectedCode(scanner: BarcodeScanner, code: String) {
            print("detected code: \(code)")
        }
        
        func barcodeScannerFailedToDetectCode(scanner: BarcodeScanner) {
            print("loaded but failed to detect code")
        }
        
        func barcodeScannerFailedToLoad(scanner: BarcodeScanner) {
            print("failed to load")
        }
    }

**Note:** In Xcode, add UIView on storyboard or xib file and set class as BarcodeScanner under Identity Inspector.


The demo project comes with a very simple interface, and interacts with vibration.

**User Interface and screenshots:**

![1](https://github.com/ahmedabdelkarim/BarcodeScanner-iOS/blob/master/Screenshots/1.jpg)    ![2](https://github.com/ahmedabdelkarim/BarcodeScanner-iOS/blob/master/Screenshots/2.jpg)    ![3](https://github.com/ahmedabdelkarim/BarcodeScanner-iOS/blob/master/Screenshots/3.jpg)    ![4](https://github.com/ahmedabdelkarim/BarcodeScanner-iOS/blob/master/Screenshots/4.jpg)    ![5](https://github.com/ahmedabdelkarim/BarcodeScanner-iOS/blob/master/Screenshots/5.jpg)
