import UserNotifications
import WebKit

class LocalNotificationsManager {

    static func requestPermission(webView: WKWebView, callbackName: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                let js = "\(callbackName)({ granted: \(granted) })"
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }

    static func checkPermission(webView: WKWebView, callbackName: String) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let status: String
                switch settings.authorizationStatus {
                case .authorized:   status = "authorized"
                case .denied:       status = "denied"
                case .provisional:  status = "provisional"
                default:            status = "notDetermined"
                }
                let js = "\(callbackName)({ status: '\(status)' })"
                webView.evaluateJavaScript(js, completionHandler: nil)
            }
        }
    }

    static func scheduleNotification(id: String, title: String, body: String, delaySeconds: Double, data: String?) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        if let data = data {
            content.userInfo = ["data": data]
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(delaySeconds, 1), repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("[LocalNotifications] Error scheduling: \(error)")
            }
        }
    }

    static func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
