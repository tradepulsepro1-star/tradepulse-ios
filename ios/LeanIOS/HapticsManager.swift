import UIKit
import WebKit

class HapticsManager {
    static func impact(style: String) {
        let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle
        switch style {
        case "light":   feedbackStyle = .light
        case "heavy":   feedbackStyle = .heavy
        case "soft":    feedbackStyle = .soft
        case "rigid":   feedbackStyle = .rigid
        default:        feedbackStyle = .medium
        }
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)
        generator.prepare()
        generator.impactOccurred()
    }

    static func notification(type: String) {
        let feedbackType: UINotificationFeedbackGenerator.FeedbackType
        switch type {
        case "warning": feedbackType = .warning
        case "error":   feedbackType = .error
        default:        feedbackType = .success
        }
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(feedbackType)
    }

    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }
}
