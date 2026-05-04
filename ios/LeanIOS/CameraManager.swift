import UIKit
import PhotosUI
import WebKit

class CameraManager: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var webView: WKWebView?
    var callbackName: String?
    var viewController: UIViewController?
    
    static let shared = CameraManager()
    
    func pickImage(webView: WKWebView, callbackName: String, viewController: UIViewController, source: String = "library") {
        self.webView = webView
        self.callbackName = callbackName
        self.viewController = viewController
        
        if source == "camera" && UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            viewController.present(picker, animated: true)
        } else {
            var config = PHPickerConfiguration()
            config.selectionLimit = 1
            config.filter = .images
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            viewController.present(picker, animated: true)
        }
    }
    
    // PHPicker delegate
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let result = results.first else {
            callJS(base64: nil)
            return
        }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            DispatchQueue.main.async {
                if let image = object as? UIImage,
                   let data = image.jpegData(compressionQuality: 0.8) {
                    let base64 = data.base64EncodedString()
                    self?.callJS(base64: base64)
                } else {
                    self?.callJS(base64: nil)
                }
            }
        }
    }
    
    // UIImagePicker delegate (camera)
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        if let image = info[.originalImage] as? UIImage,
           let data = image.jpegData(compressionQuality: 0.8) {
            let base64 = data.base64EncodedString()
            callJS(base64: base64)
        } else {
            callJS(base64: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        callJS(base64: nil)
    }
    
    private func callJS(base64: String?) {
        guard let callback = callbackName, let webView = webView else { return }
        let js: String
        if let b64 = base64 {
            js = "\(callback)({ success: true, uri: 'data:image/jpeg;base64,\(b64)' })"
        } else {
            js = "\(callback)({ success: false })"
        }
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
}
