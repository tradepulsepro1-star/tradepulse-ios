//
//  NativeBridgeRound3.swift
//  TradePulse
//
//  Round 3 Native Plugins (Growth Phase v2):
//  - Analytics / Event Tracking
//  - Calendar Access
//  - Location Services
//  - Clipboard
//
//  Called from web via: window.TradePulseNative.<method>(args)
//

import UIKit
import WebKit
import EventKit
import CoreLocation
import CoreMotion

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Round 3 Extension on NativeBridge
// ─────────────────────────────────────────────────────────────────────────────

extension NativeBridge {

    // ─── Register Round 3 handlers ────────────────────────────────────────────
    func setupRound3MessageHandlers() {
        let handlers = [
            // Analytics
            "trackEvent", "trackScreen", "trackTrade", "setUserProperties",
            // Calendar
            "requestCalendarPermission", "addCalendarEvent", "removeCalendarEvent", "listCalendarEvents",
            // Location
            "requestLocationPermission", "getCurrentLocation", "startLocationUpdates", "stopLocationUpdates",
            // Clipboard
            "copyToClipboard", "readClipboard", "clearClipboard"
        ]
        for h in handlers {
            webView?.configuration.userContentController.add(self, name: h)
        }
        injectRound3JSBridge()
    }

    // ─── Inject Round 3 JS shim ───────────────────────────────────────────────
    func injectRound3JSBridge() {
        let js = """
        window.TradePulseNative = window.TradePulseNative || {};
        Object.assign(window.TradePulseNative, {

            // ── Analytics ──────────────────────────────────────────────────────
            trackEvent: function(eventName, properties) {
                window.webkit.messageHandlers.trackEvent.postMessage({
                    eventName: eventName,
                    properties: JSON.stringify(properties || {})
                });
            },
            trackScreen: function(screenName) {
                window.webkit.messageHandlers.trackScreen.postMessage({ screenName: screenName });
            },
            trackTrade: function(ticker, direction, entry, target, stop) {
                window.webkit.messageHandlers.trackTrade.postMessage({
                    ticker: ticker, direction: direction,
                    entry: entry, target: target, stop: stop
                });
            },
            setUserProperties: function(properties) {
                window.webkit.messageHandlers.setUserProperties.postMessage({
                    properties: JSON.stringify(properties || {})
                });
            },

            // ── Calendar ───────────────────────────────────────────────────────
            requestCalendarPermission: function(cb) {
                window.webkit.messageHandlers.requestCalendarPermission.postMessage({ callback: cb || '' });
            },
            addCalendarEvent: function(title, notes, startDate, endDate, cb) {
                window.webkit.messageHandlers.addCalendarEvent.postMessage({
                    title: title, notes: notes || '',
                    startDate: startDate, endDate: endDate || startDate,
                    callback: cb || ''
                });
            },
            removeCalendarEvent: function(eventId, cb) {
                window.webkit.messageHandlers.removeCalendarEvent.postMessage({ eventId: eventId, callback: cb || '' });
            },
            listCalendarEvents: function(startDate, endDate, cb) {
                window.webkit.messageHandlers.listCalendarEvents.postMessage({
                    startDate: startDate, endDate: endDate, callback: cb || ''
                });
            },

            // ── Location ───────────────────────────────────────────────────────
            requestLocationPermission: function(cb) {
                window.webkit.messageHandlers.requestLocationPermission.postMessage({ callback: cb || '' });
            },
            getCurrentLocation: function(cb) {
                window.webkit.messageHandlers.getCurrentLocation.postMessage({ callback: cb || '' });
            },
            startLocationUpdates: function() {
                window.webkit.messageHandlers.startLocationUpdates.postMessage({});
            },
            stopLocationUpdates: function() {
                window.webkit.messageHandlers.stopLocationUpdates.postMessage({});
            },

            // ── Clipboard ──────────────────────────────────────────────────────
            copyToClipboard: function(text, cb) {
                window.webkit.messageHandlers.copyToClipboard.postMessage({ text: text, callback: cb || '' });
            },
            readClipboard: function(cb) {
                window.webkit.messageHandlers.readClipboard.postMessage({ callback: cb || '' });
            },
            clearClipboard: function() {
                window.webkit.messageHandlers.clearClipboard.postMessage({});
            }
        });
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView?.configuration.userContentController.addUserScript(script)
    }

    // ─── Round 3 message dispatcher ───────────────────────────────────────────
    func handleRound3Message(_ name: String, body: [String: Any]) {
        switch name {
        // Analytics
        case "trackEvent":          handleTrackEvent(body)
        case "trackScreen":         handleTrackScreen(body)
        case "trackTrade":          handleTrackTrade(body)
        case "setUserProperties":   handleSetUserProperties(body)
        // Calendar
        case "requestCalendarPermission": handleCalendarPermission(body)
        case "addCalendarEvent":    handleAddCalendarEvent(body)
        case "removeCalendarEvent": handleRemoveCalendarEvent(body)
        case "listCalendarEvents":  handleListCalendarEvents(body)
        // Location
        case "requestLocationPermission": handleLocationPermission(body)
        case "getCurrentLocation":  handleGetCurrentLocation(body)
        case "startLocationUpdates": locationManager.startUpdatingLocation()
        case "stopLocationUpdates":  locationManager.stopUpdatingLocation()
        // Clipboard
        case "copyToClipboard":     handleCopyToClipboard(body)
        case "readClipboard":       handleReadClipboard(body)
        case "clearClipboard":      UIPasteboard.general.string = ""
        default: break
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Analytics / Event Tracking
// ─────────────────────────────────────────────────────────────────────────────

// In-memory event log (flushed to backend via JS dispatch)
private var _analyticsQueue: [[String: Any]] = []

extension NativeBridge {

    func handleTrackEvent(_ body: [String: Any]) {
        let eventName  = body["eventName"] as? String ?? "unknown_event"
        let properties = body["properties"] as? String ?? "{}"
        let entry: [String: Any] = [
            "event": eventName,
            "properties": properties,
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "platform": "ios"
        ]
        _analyticsQueue.append(entry)
        // Dispatch back to web layer for backend persistence
        dispatchEvent("tradepulse_analytics_event", detail: [
            "event": eventName,
            "properties": properties,
            "platform": "ios"
        ])
        // Auto-flush every 10 events
        if _analyticsQueue.count >= 10 { flushAnalytics() }
    }

    func handleTrackScreen(_ body: [String: Any]) {
        let screen = body["screenName"] as? String ?? ""
        handleTrackEvent(["eventName": "screen_view", "properties": "{\"screen\":\"\(screen)\"}"])
    }

    func handleTrackTrade(_ body: [String: Any]) {
        let ticker    = body["ticker"] as? String ?? ""
        let direction = body["direction"] as? String ?? ""
        let entry     = body["entry"] as? Double ?? 0
        let target    = body["target"] as? Double ?? 0
        let stop      = body["stop"] as? Double ?? 0
        let props     = "{\"ticker\":\"\(ticker)\",\"direction\":\"\(direction)\",\"entry\":\(entry),\"target\":\(target),\"stop\":\(stop)}"
        handleTrackEvent(["eventName": "trade_signal_viewed", "properties": props])
    }

    func handleSetUserProperties(_ body: [String: Any]) {
        let properties = body["properties"] as? String ?? "{}"
        dispatchEvent("tradepulse_user_properties", detail: ["properties": properties, "platform": "ios"])
    }

    func flushAnalytics() {
        guard !_analyticsQueue.isEmpty else { return }
        if let data = try? JSONSerialization.data(withJSONObject: _analyticsQueue),
           let json = String(data: data, encoding: .utf8) {
            dispatchEvent("tradepulse_analytics_flush", detail: ["events": json, "count": "\(_analyticsQueue.count)"])
        }
        _analyticsQueue.removeAll()
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Calendar Access
// ─────────────────────────────────────────────────────────────────────────────

private let _eventStore = EKEventStore()

extension NativeBridge {

    func handleCalendarPermission(_ body: [String: Any]) {
        if #available(iOS 17.0, *) {
            _eventStore.requestWriteOnlyAccessToEvents { granted, _ in
                self.dispatchEvent("tradepulse_calendar_permission", detail: ["granted": granted])
            }
        } else {
            _eventStore.requestAccess(to: .event) { granted, _ in
                self.dispatchEvent("tradepulse_calendar_permission", detail: ["granted": granted])
            }
        }
    }

    func handleAddCalendarEvent(_ body: [String: Any]) {
        let title     = body["title"] as? String ?? "TradePulse Signal"
        let notes     = body["notes"] as? String ?? ""
        let startStr  = body["startDate"] as? String ?? ""
        let endStr    = body["endDate"] as? String ?? startStr

        let formatter = ISO8601DateFormatter()
        guard let start = formatter.date(from: startStr) else {
            dispatchEvent("tradepulse_calendar_error", detail: ["error": "Invalid start date"]); return
        }
        let end = formatter.date(from: endStr) ?? start.addingTimeInterval(3600)

        let event       = EKEvent(eventStore: _eventStore)
        event.title     = title
        event.notes     = notes
        event.startDate = start
        event.endDate   = end
        event.calendar  = _eventStore.defaultCalendarForNewEvents

        do {
            try _eventStore.save(event, span: .thisEvent)
            dispatchEvent("tradepulse_calendar_event_added", detail: ["eventId": event.eventIdentifier ?? "", "title": title])
        } catch {
            dispatchEvent("tradepulse_calendar_error", detail: ["error": error.localizedDescription])
        }
    }

    func handleRemoveCalendarEvent(_ body: [String: Any]) {
        guard let eventId = body["eventId"] as? String,
              let event = _eventStore.event(withIdentifier: eventId) else {
            dispatchEvent("tradepulse_calendar_error", detail: ["error": "Event not found"]); return
        }
        do {
            try _eventStore.remove(event, span: .thisEvent)
            dispatchEvent("tradepulse_calendar_event_removed", detail: ["eventId": eventId])
        } catch {
            dispatchEvent("tradepulse_calendar_error", detail: ["error": error.localizedDescription])
        }
    }

    func handleListCalendarEvents(_ body: [String: Any]) {
        let formatter = ISO8601DateFormatter()
        let startStr  = body["startDate"] as? String ?? ""
        let endStr    = body["endDate"] as? String ?? ""
        guard let start = formatter.date(from: startStr),
              let end   = formatter.date(from: endStr) else {
            dispatchEvent("tradepulse_calendar_error", detail: ["error": "Invalid dates"]); return
        }
        let predicate = _eventStore.predicateForEvents(withStart: start, end: end, calendars: nil)
        let events    = _eventStore.events(matching: predicate)
        var list: [[String: String]] = []
        for e in events {
            list.append([
                "id":    e.eventIdentifier ?? "",
                "title": e.title ?? "",
                "start": formatter.string(from: e.startDate),
                "end":   formatter.string(from: e.endDate)
            ])
        }
        if let data = try? JSONSerialization.data(withJSONObject: list),
           let json = String(data: data, encoding: .utf8) {
            dispatchEvent("tradepulse_calendar_events", detail: ["events": json])
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Location Services
// ─────────────────────────────────────────────────────────────────────────────

// CLLocationManagerDelegate implemented via NativeBridgeLocation.swift shim below
let locationManager = CLLocationManager()
private var _locationDelegate: NativeBridgeLocationDelegate?

extension NativeBridge {

    func setupLocationManager() {
        _locationDelegate = NativeBridgeLocationDelegate(bridge: self)
        locationManager.delegate = _locationDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func handleLocationPermission(_ body: [String: Any]) {
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        let granted = (status == .authorizedWhenInUse || status == .authorizedAlways)
        dispatchEvent("tradepulse_location_permission", detail: ["granted": granted])
    }

    func handleGetCurrentLocation(_ body: [String: Any]) {
        let status = CLLocationManager.authorizationStatus()
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            dispatchEvent("tradepulse_location_error", detail: ["error": "Location permission not granted"]); return
        }
        locationManager.requestLocation()
    }

    func dispatchLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, _ in
            let place    = placemarks?.first
            let city     = place?.locality ?? ""
            let country  = place?.country ?? ""
            let timezone = place?.timeZone?.identifier ?? TimeZone.current.identifier
            self.dispatchEvent("tradepulse_location", detail: [
                "lat":      "\(location.coordinate.latitude)",
                "lng":      "\(location.coordinate.longitude)",
                "city":     city,
                "country":  country,
                "timezone": timezone
            ])
        }
    }
}

// Separate delegate class to avoid protocol conflicts
class NativeBridgeLocationDelegate: NSObject, CLLocationManagerDelegate {
    weak var bridge: NativeBridge?
    init(bridge: NativeBridge) { self.bridge = bridge }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        bridge?.dispatchLocation(loc)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        bridge?.dispatchEvent("tradepulse_location_error", detail: ["error": error.localizedDescription])
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status  = manager.authorizationStatus
        let granted = (status == .authorizedWhenInUse || status == .authorizedAlways)
        bridge?.dispatchEvent("tradepulse_location_permission", detail: ["granted": granted])
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Clipboard
// ─────────────────────────────────────────────────────────────────────────────

extension NativeBridge {

    func handleCopyToClipboard(_ body: [String: Any]) {
        guard let text = body["text"] as? String else { return }
        UIPasteboard.general.string = text
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dispatchEvent("tradepulse_clipboard_copied", detail: ["text": text])
    }

    func handleReadClipboard(_ body: [String: Any]) {
        let text = UIPasteboard.general.string ?? ""
        dispatchEvent("tradepulse_clipboard_value", detail: ["text": text, "hasContent": text.isEmpty ? "false" : "true"])
    }
}
