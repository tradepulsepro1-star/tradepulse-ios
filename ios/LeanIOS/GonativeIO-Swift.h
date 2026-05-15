// GonativeIO-Swift.h
// ObjC-compatible forward declarations for @objc Swift classes.
// Xcode normally auto-generates this — we provide it manually since
// we don't compile with the full GoNativeCore Swift module.

#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#ifndef SWIFT_CLASS
#define SWIFT_CLASS(SWIFT_NAME) __attribute__((objc_runtime_name(SWIFT_NAME))) __attribute__((swift_name(SWIFT_NAME)))
#endif

#ifndef SWIFT_CLASS_NAMED
#define SWIFT_CLASS_NAMED(SWIFT_NAME) __attribute__((objc_runtime_name(SWIFT_NAME))) __attribute__((swift_name(SWIFT_NAME)))
#endif

// LEANIcons — SF Symbol image resolver
SWIFT_CLASS("LEANIcons")
@interface LEANIcons : NSObject
@property (class, readonly, strong) LEANIcons * _Nonnull sharedIcons;
+ (UIImage * _Nullable)imageForIconIdentifier:(NSString * _Nonnull)name size:(CGFloat)size color:(UIColor * _Nonnull)color;
@end

// CustomMenu — floating action menu rendered in a UIView
SWIFT_CLASS("CustomMenu")
@interface CustomMenu : UIView
- (nonnull instancetype)initWithContainer:(UIView * _Nonnull)container
                                   button:(UIButton * _Nonnull)button
                                     data:(NSArray * _Nonnull)data
                                    onTap:(void (^ _Nullable)(NSDictionary * _Nullable))onTap;
- (void)setMenuColor:(UIColor * _Nonnull)color;
@end

// GNSwiftUtilities — device token helper
SWIFT_CLASS("GNSwiftUtilities")
@interface GNSwiftUtilities : NSObject
+ (NSString * _Nonnull)deviceTokenWithData:(NSData * _Nonnull)data;
@end

// WebViewViewportManager — viewport/zoom control
SWIFT_CLASS("WebViewViewportManager")
@interface WebViewViewportManager : NSObject
@property (class, readonly, strong) WebViewViewportManager * _Nonnull shared;
- (void)setViewportWithScale:(CGFloat)scale width:(NSNumber * _Nullable)width webView:(WKWebView * _Nullable)webView;
- (void)handleUrl:(NSURL * _Nonnull)url query:(NSDictionary<AnyHashable *, id> * _Nonnull)query webView:(WKWebView * _Nullable)webView completion:(void (^ _Nonnull)(NSDictionary<AnyHashable *, id> * _Nonnull))completion;
- (void)getViewportScaleWithWebView:(WKWebView * _Nullable)webView completion:(void (^ _Nonnull)(NSDictionary<AnyHashable *, id> * _Nonnull))completion;
- (void)updateViewport;
@end

// WindowsController — multi-window management
SWIFT_CLASS("WindowsController")
@interface WindowsController : NSObject
+ (void)windowCountChanged;
@end

// ContextMenuHandler — long-press context menu
SWIFT_CLASS("ContextMenuHandler")
@interface ContextMenuHandler : NSObject
+ (UIContextMenuConfiguration * _Nullable)createConfigurationWithUrl:(NSURL * _Nonnull)url shareAction:(void (^ _Nonnull)(void))shareAction API_AVAILABLE(ios(13.0));
@end
