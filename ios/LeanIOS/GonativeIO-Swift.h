// GonativeIO-Swift.h
// Manually maintained ObjC interfaces for @objc Swift classes.
// Xcode cannot auto-generate this because the module uses local stubs.

#ifndef GonativeIO_Swift_h
#define GonativeIO_Swift_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// LEANIcons — defined in LEANIcons.swift
@interface LEANIcons : NSObject
@property (class, nonatomic, strong, readonly) LEANIcons *sharedIcons;
+ (UIImage *)imageForIconIdentifier:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
@end

// GNSwiftUtilities — defined in GNSwiftUtilities.swift
@interface GNSwiftUtilities : NSObject
+ (NSString *)deviceTokenWithData:(NSData *)data;
@end

// WebViewViewportManager — defined in WebViewViewportManager.swift
@interface WebViewViewportManager : NSObject
- (void)setViewportWithScale:(CGFloat)scale width:(NSNumber *)width webView:(WKWebView *)webView;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query webView:(WKWebView *)webView wvc:(id)wvc;
- (void)getViewportScale:(WKWebView *)webView completion:(void (^)(NSDictionary *))completion;
- (void)updateViewport;
@end

// WindowsController — defined in WindowsController.swift
@interface WindowsController : NSObject
+ (void)windowCountChanged;
@end

// CustomMenu — defined in CustomMenu.swift
@interface CustomMenu : UIView
- (void)setMenuColor:(UIColor *)color;
@end

// ContextMenuHandler — defined in ContextMenuHandler.swift
@interface ContextMenuHandler : NSObject
+ (UIContextMenuConfiguration *)createConfigurationWithUrl:(NSURL *)url shareAction:(void (^)(void))shareAction;
@end

// UIApplication extension — defined in UIApplication+Extensions.swift
@interface UIApplication (GonativeSwiftExtensions)
@property (nonatomic, readonly) UIWindow *currentKeyWindow;
@property (nonatomic, readonly) CGRect currentStatusBarFrame;
@property (nonatomic, readonly) BOOL isInterfaceOrientationPortrait;
@end

#endif /* GonativeIO_Swift_h */
