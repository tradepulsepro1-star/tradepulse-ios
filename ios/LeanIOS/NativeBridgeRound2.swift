//
//  NativeBridgeRound2.swift
//  TradePulse
//
//  Round 2 Native Plugins:
//  - Background Tasks (BGTaskScheduler)
//  - WebSockets (live price/signal streaming)
//  - QR Code Scanner (AVFoundation)
//  - Chat Upgrades (typing indicators, read receipts, message sounds)
//
//  Called from web via: window.TradePulseNative.<method>(args)
//

import UIKit
import WebKit
import AVFoundation
import BackgroundTasks
import AudioToolbox

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Round 2 Extension on NativeBridge
// ─────────────────────────────────────────────────────────────────────────────

extension NativeBridge: AVCaptureMetadataOutputObjectsDelegate {

    // ─── Register Round 2 handlers ────────────────────────────────────────────
    func setupRound2MessageHandlers() {
        let handlers = [
            // WebSocket
            "wsConnect", "wsSend", "wsDisconnect",
            // QR Scanner
            "openQRScanner", "closeQRScanner",
            // Background Tasks
            "registerBackgroundTask", "scheduleBackgroundFetch",
            // Chat upgrades
            "playMessageSound", "vibrateChatNotification",
            "markMessagesRead", "setTypingIndicator"
        ]
        for h in handlers {
            webView?.configuration.userContentController.add(self, name: h)
        }
        injectRound2JSBridge()
    }

    // ─── Inject Round 2 JS shim ───────────────────────────────────────────────
    func injectRound2JSBridge() {
        let js = """
        window.TradePulseNative = window.TradePulseNative || {};
        Object.assign(window.TradePulseNative, {
            // WebSocket
            wsConnect: function(url, protocols) {
                window.webkit.messageHandlers.wsConnect.postMessage({ url: url, protocols: protocols || [] });
            },
            wsSend: function(message) {
                window.webkit.messageHandlers.wsSend.postMessage({ message: message });
            },
            wsDisconnect: function() {
                window.webkit.messageHandlers.wsDisconnect.postMessage({});
            },
            // QR Scanner
            openQRScanner: function(cb) {
                window.webkit.messageHandlers.openQRScanner.postMessage({ callback: cb || '' });
            },
            closeQRScanner: function() {
                window.webkit.messageHandlers.closeQRScanner.postMessage({});
            },
            // Background Tasks
            registerBackgroundTask: function(taskId) {
                window.webkit.messageHandlers.registerBackgroundTask.postMessage({ taskId: taskId });
            },
            scheduleBackgroundFetch: function(minInterval) {
                window.webkit.messageHandlers.scheduleBackgroundFetch.postMessage({ minInterval: minInterval || 900 });
            },
            // Chat
            playMessageSound: function(type) {
                window.webkit.messageHandlers.playMessageSound.postMessage({ type: type || 'receive' });
            },
            vibrateChatNotification: function() {
                window.webkit.messageHandlers.vibrateChatNotification.postMessage({});
            },
            markMessagesRead: function(chatId) {
                window.webkit.messageHandlers.markMessagesRead.postMessage({ chatId: chatId });
            },
            setTypingIndicator: function(chatId, isTyping) {
                window.webkit.messageHandlers.setTypingIndicator.postMessage({ chatId: chatId, isTyping: isTyping });
            }
        });
        """
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        webView?.configuration.userContentController.addUserScript(script)
    }

    // ─── Round 2 message dispatcher (call from main userContentController handler) ─
    func handleRound2Message(_ name: String, body: [String: Any]) {
        switch name {
        case "wsConnect":               handleWSConnect(body)
        case "wsSend":                  handleWSSend(body)
        case "wsDisconnect":            handleWSDisconnect()
        case "openQRScanner":           handleOpenQRScanner(body)
        case "closeQRScanner":          handleCloseQRScanner()
        case "registerBackgroundTask":  handleRegisterBackgroundTask(body)
        case "scheduleBackgroundFetch": handleScheduleBackgroundFetch(body)
        case "playMessageSound":        handlePlayMessageSound(body)
        case "vibrateChatNotification": UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case "markMessagesRead":        handleMarkMessagesRead(body)
        case "setTypingIndicator":      handleSetTypingIndicator(body)
        default: break
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - WebSocket Manager
// ─────────────────────────────────────────────────────────────────────────────

private var _webSocketTask: URLSessionWebSocketTask?
private var _webSocketSession: URLSession?

extension NativeBridge {

    func handleWSConnect(_ body: [String: Any]) {
        guard let urlStr = body["url"] as? String, let url = URL(string: urlStr) else {
            dispatchEvent("tradepulse_ws_error", detail: ["error": "Invalid WebSocket URL"]); return
        }
        _webSocketSession = URLSession(configuration: .default)
        _webSocketTask = _webSocketSession?.webSocketTask(with: url)
        _webSocketTask?.resume()
        dispatchEvent("tradepulse_ws_open", detail: ["url": urlStr])
        receiveWSMessage()
    }

    func receiveWSMessage() {
        _webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let msg):
                switch msg {
                case .string(let text):
                    self?.dispatchEvent("tradepulse_ws_message", detail: ["data": text, "type": "string"])
                case .data(let data):
                    let text = String(data: data, encoding: .utf8) ?? ""
                    self?.dispatchEvent("tradepulse_ws_message", detail: ["data": text, "type": "binary"])
                @unknown default: break
                }
                self?.receiveWSMessage() // keep listening
            case .failure(let error):
                self?.dispatchEvent("tradepulse_ws_close", detail: ["error": error.localizedDescription])
            }
        }
    }

    func handleWSSend(_ body: [String: Any]) {
        guard let message = body["message"] as? String else { return }
        _webSocketTask?.send(.string(message)) { error in
            if let e = error {
                self.dispatchEvent("tradepulse_ws_error", detail: ["error": e.localizedDescription])
            }
        }
    }

    func handleWSDisconnect() {
        _webSocketTask?.cancel(with: .normalClosure, reason: nil)
        _webSocketTask = nil
        dispatchEvent("tradepulse_ws_close", detail: ["error": ""])
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - QR Code Scanner
// ─────────────────────────────────────────────────────────────────────────────

private var _captureSession: AVCaptureSession?
private var _qrOverlayVC: UIViewController?

extension NativeBridge {

    func handleOpenQRScanner(_ body: [String: Any]) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.dispatchEvent("tradepulse_qr_error", detail: ["error": "Camera permission denied"]); return
                }
                self.launchQRScanner()
            }
        }
    }

    func launchQRScanner() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            dispatchEvent("tradepulse_qr_error", detail: ["error": "Cannot access camera"]); return
        }
        let session = AVCaptureSession()
        _captureSession = session
        session.addInput(input)
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: .main)
        output.metadataObjectTypes = [.qr, .ean8, .ean13, .upce, .code128, .code39, .code93, .pdf417]

        let overlayVC = UIViewController()
        overlayVC.view.backgroundColor = .black
        _qrOverlayVC = overlayVC

        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = overlayVC.view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        overlayVC.view.layer.addSublayer(previewLayer)

        // Close button
        let closeBtn = UIButton(type: .system)
        closeBtn.setTitle("✕  Close", for: .normal)
        closeBtn.setTitleColor(.white, for: .normal)
        closeBtn.backgroundColor = UIColor(white: 0, alpha: 0.6)
        closeBtn.layer.cornerRadius = 12
        closeBtn.frame = CGRect(x: 20, y: 60, width: 100, height: 40)
        closeBtn.addTarget(self, action: #selector(closeQRScannerFromButton), for: .touchUpInside)
        overlayVC.view.addSubview(closeBtn)

        // Scan frame overlay
        let scanFrame = UIView(frame: CGRect(x: 80, y: 160, width: 220, height: 220))
        scanFrame.layer.borderColor = UIColor(red: 0.96, green: 0.78, blue: 0.26, alpha: 1).cgColor
        scanFrame.layer.borderWidth = 3
        scanFrame.layer.cornerRadius = 12
        overlayVC.view.addSubview(scanFrame)

        overlayVC.modalPresentationStyle = .fullScreen
        viewController?.present(overlayVC, animated: true) { session.startRunning() }
    }

    @objc func closeQRScannerFromButton() {
        handleCloseQRScanner()
    }

    func handleCloseQRScanner() {
        DispatchQueue.main.async {
            self._captureSession?.stopRunning()
            self._captureSession = nil
            self._qrOverlayVC?.dismiss(animated: true)
            self._qrOverlayVC = nil
        }
    }

    // AVCaptureMetadataOutputObjectsDelegate
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                                didOutput metadataObjects: [AVMetadataObject],
                                from connection: AVCaptureConnection) {
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let value = obj.stringValue else { return }
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        dispatchEvent("tradepulse_qr_scanned", detail: ["value": value, "type": obj.type.rawValue])
        handleCloseQRScanner()
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Background Tasks
// ─────────────────────────────────────────────────────────────────────────────

extension NativeBridge {

    func handleRegisterBackgroundTask(_ body: [String: Any]) {
        let taskId = body["taskId"] as? String ?? "net.tradepulsepro.refresh"
        if #available(iOS 13.0, *) {
            BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
                self.dispatchEvent("tradepulse_background_task", detail: ["taskId": taskId])
                // Schedule next fetch
                self.scheduleAppRefresh(taskId: taskId, minInterval: 900)
                task.setTaskCompleted(success: true)
            }
        }
        dispatchEvent("tradepulse_bg_task_registered", detail: ["taskId": taskId])
    }

    func handleScheduleBackgroundFetch(_ body: [String: Any]) {
        let minInterval = body["minInterval"] as? Double ?? 900
        let taskId = "net.tradepulsepro.refresh"
        scheduleAppRefresh(taskId: taskId, minInterval: minInterval)
        dispatchEvent("tradepulse_bg_fetch_scheduled", detail: ["minInterval": "\(Int(minInterval))"])
    }

    func scheduleAppRefresh(taskId: String, minInterval: Double) {
        if #available(iOS 13.0, *) {
            let request = BGAppRefreshTaskRequest(identifier: taskId)
            request.earliestBeginDate = Date(timeIntervalSinceNow: minInterval)
            try? BGTaskScheduler.shared.submit(request)
        }
    }
}

// ─────────────────────────────────────────────────────────────────────────────
// MARK: - Chat Upgrades
// ─────────────────────────────────────────────────────────────────────────────

extension NativeBridge {

    func handlePlayMessageSound(_ body: [String: Any]) {
        let type = body["type"] as? String ?? "receive"
        DispatchQueue.global(qos: .userInitiated).async {
            // System sounds: 1003 = SMS received, 1004 = sent
            let soundId: SystemSoundID = (type == "send") ? 1004 : 1003
            AudioServicesPlaySystemSound(soundId)
        }
    }

    func handleMarkMessagesRead(_ body: [String: Any]) {
        // Dispatch event back to web layer to update unread badges
        let chatId = body["chatId"] as? String ?? ""
        dispatchEvent("tradepulse_messages_read", detail: ["chatId": chatId])
        // Clear app badge if no more unread
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                let remaining = notifications.filter { $0.request.content.userInfo["chatId"] as? String != chatId }
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = remaining.count
                }
            }
        }
    }

    func handleSetTypingIndicator(_ body: [String: Any]) {
        let chatId  = body["chatId"] as? String ?? ""
        let isTyping = body["isTyping"] as? Bool ?? false
        // Dispatch to web layer to show/hide typing bubble UI
        dispatchEvent("tradepulse_typing_indicator", detail: ["chatId": chatId, "isTyping": isTyping])
    }
}
