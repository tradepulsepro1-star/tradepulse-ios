// GonativeIO-Swift.h
// ObjC-visible declarations for @objc Swift classes used by this project.
// Xcode auto-generates this at build time from Swift @objc classes.
// This handwritten version covers every class/method that ObjC files actually call.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#pragma mark - LEANIcons
// Swift: @objc public class LEANIcons: NSObject
// Used by: LEANToolbarManager.m, LEANTabManager.m, LEANActionManager.m
@interface LEANIcons : NSObject
+ (UIImage * _Nullable)imageForIconIdentifier:(NSString * _Nonnull)name size:(CGFloat)size color:(UIColor * _Nonnull)color;
@property (class, nonatomic, readonly, strong) LEANIcons * _Nonnull sharedIcons;
- (nonnull instancetype)init;
@end

#pragma mark - WebViewViewportManager
// Swift: @objc public final class WebViewViewportManager: NSObject
// Used by: LEANUtilities.m
@interface WebViewViewportManager : NSObject
@property (class, nonatomic, readonly, strong) WebViewViewportManager * _Nonnull shared;
- (void)setViewportWithScale:(CGFloat)scale width:(NSNumber * _Nullable)width webView:(WKWebView * _Nullable)webView;
- (void)handleUrl:(NSURL * _Nonnull)url query:(NSDictionary * _Nonnull)query webView:(WKWebView * _Nullable)webView completion:(void (^ _Nullable)(NSDictionary * _Nonnull))completion;
- (void)getViewportScale:(WKWebView * _Nullable)webView completion:(void (^ _Nonnull)(NSDictionary * _Nonnull))completion;
- (void)updateViewport;
- (nonnull instancetype)init;
@end

#pragma mark - WindowsController
// Swift: @objc public class WindowsController: NSObject
@interface WindowsController : NSObject
+ (void)windowCountChanged;
- (nonnull instancetype)init;
@end
