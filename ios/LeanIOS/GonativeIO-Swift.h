// GonativeIO-Swift.h — manual ObjC-compatible stub for Swift @objc classes
// Declares Swift @objc classes visible to Objective-C files in this project.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

// LEANIcons — declared in LEANIcons.swift
// Used by: LEANToolbarManager.m, LEANActionManager.m, LEANTabManager.m
__attribute__((objc_subclassing_restricted))
@interface LEANIcons : NSObject
+ (UIImage * _Nullable)imageForIconIdentifier:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
@end

// CustomMenu — declared in CustomMenu.swift
// Used by: LEANActionManager.m
__attribute__((objc_subclassing_restricted))
@interface CustomMenu : UIView
- (instancetype)initWithContainer:(UIView *)container button:(UIButton *)button data:(NSArray *)data onTap:(void (^ _Nullable)(NSDictionary * _Nullable))onTap;
- (void)setMenuColor:(UIColor *)color;
@end

// WebViewViewportManager — declared in WebViewViewportManager.swift
// Used by: LEANUtilities.m
__attribute__((objc_subclassing_restricted))
@interface WebViewViewportManager : NSObject
@property (class, readonly) WebViewViewportManager *shared;
- (void)setViewportWithScale:(CGFloat)scale width:(NSNumber * _Nullable)width webView:(WKWebView * _Nullable)webView;
@end

// GNSwiftUtilities — declared in GNSwiftUtilities.swift
// Used by: LEANAppDelegate.m
__attribute__((objc_subclassing_restricted))
@interface GNSwiftUtilities : NSObject
+ (NSString *)deviceTokenWithData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
