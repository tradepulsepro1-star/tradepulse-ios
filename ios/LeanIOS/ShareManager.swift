import UIKit
import WebKit

class ShareManager {
    static func share(text: String, url: String?, viewController: UIViewController) {
        var items: [Any] = [text]
        if let urlStr = url, let shareURL = URL(string: urlStr) {
            items.append(shareURL)
        }
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)

        // iPad support
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX,
                                        y: viewController.view.bounds.midY,
                                        width: 0, height: 0)
            popover.permittedArrowDirections = []
        }

        viewController.present(activityVC, animated: true, completion: nil)
    }
}
