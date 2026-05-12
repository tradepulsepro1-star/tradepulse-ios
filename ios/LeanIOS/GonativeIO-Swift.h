// GonativeIO-Swift.h — Stub replacing Xcode-generated Swift-ObjC bridge

#ifndef GonativeIO_Swift_h
#define GonativeIO_Swift_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// Define Swift interop macros if not already defined
#ifndef SWIFT_CLASS
#define SWIFT_CLASS(SWIFT_NAME)
#endif
#ifndef SWIFT_PROTOCOL
#define SWIFT_PROTOCOL(SWIFT_NAME)
#endif

NS_ASSUME_NONNULL_BEGIN

/// Protocol for native plugin controllers (splash screen, loading spinner, etc.)
@protocol GNController <NSObject>
@optional
- (void)triggerEvent:(NSString *)eventName;
@end

/// WebViewViewportManager — stub for Swift class exposed to ObjC
@interface WebViewViewportManager : NSObject
@property (class, nonatomic, readonly) WebViewViewportManager *shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query webView:(WKWebView * _Nullable)webView completion:(void (^)(NSDictionary *))completion;
- (void)setViewportWithScale:(NSNumber * _Nullable)scale width:(NSNumber * _Nullable)width webView:(WKWebView * _Nullable)webView;
- (void)getViewportScaleWithWebView:(WKWebView * _Nullable)webView completion:(void (^)(NSDictionary *))completion;
@end

/// WindowsController — stub for Swift class exposed to ObjC
@interface WindowsController : NSObject
+ (void)windowCountChanged;
@end

/// ContextMenuHandler — stub for Swift class exposed to ObjC
@interface ContextMenuHandler : NSObject
+ (UIContextMenuConfiguration * _Nullable)createConfigurationWithUrl:(NSURL *)url shareAction:(void (^)(void))shareAction;
@end

NS_ASSUME_NONNULL_END

#endif /* GonativeIO_Swift_h */
