
# BarcodeScanner-iOS
Custom control written in Swift 5 for scanning barcode, with demo project showing capabilities of BarcodeScanner control.

**BarcodeScanner:**
* Written in Swift 5
* Scans QR code [others in progress]
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

//adding screenshots in progress
