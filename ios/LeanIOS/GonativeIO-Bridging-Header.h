//
//  GonativeIO-Bridging-Header.h — Minimal Swift bridging header
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// GoNativeAppConfig: used by ContextMenuHandler.swift and WebViewViewportManager.swift
#import "GoNativeAppConfig.h"

// Stubs for GN framework types used in Swift-accessible ObjC
#import "GNBridge.h"
#import "GNEventEmitter.h"
#import "GNJSBridgeHandler.h"
#import "GNUtilities.h"
