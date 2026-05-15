// GonativeIO-Stubs.h
// Imports ObjC headers for classes previously defined in Swift.
// Now all implemented in pure ObjC — no Swift bridging needed.

#ifndef GonativeIO_Stubs_h
#define GonativeIO_Stubs_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "LEANIcons.h"
#import "GNSwiftUtilities.h"
#import "WebViewViewportManager.h"

// CustomMenu — still in Swift, declared here for ObjC callers
@interface CustomMenu : UIView
- (instancetype)initWithContainer:(UIView *)container button:(UIButton *)button data:(NSArray *)data onTap:(void (^ _Nullable)(NSDictionary * _Nullable))onTap;
- (void)setMenuColor:(UIColor *)color;
@end

// ContextMenuHandler — still in Swift, declared here for ObjC callers
@interface ContextMenuHandler : NSObject
+ (UIContextMenuConfiguration * _Nullable)createConfigurationWithUrl:(NSURL * _Nonnull)url shareAction:(void (^ _Nullable)(void))shareAction;
@end

// WindowsController — still in Swift, declared here for ObjC callers
@interface WindowsController : NSObject
+ (void)windowCountChanged;
@end

// UIApplication extension — still in Swift, declared here for ObjC callers
@interface UIApplication (GonativeSwiftExtensions)
@property (nonatomic, readonly, nullable) UIWindow *currentKeyWindow;
@property (nonatomic, readonly) CGRect currentStatusBarFrame;
@property (nonatomic, readonly) BOOL isInterfaceOrientationPortrait;
@end

#endif /* GonativeIO_Stubs_h */
