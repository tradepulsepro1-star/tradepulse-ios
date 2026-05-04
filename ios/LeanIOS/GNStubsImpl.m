//
// GNStubsImpl.m - Implementations for GoNativeCore stubs
//

#import "GNStubs.h"
#import <UIKit/UIKit.h>

// Notification constants
NSString * const kGoNativeAppConfigNotificationUserAgentReady = @"co.median.ios.AppConfig.userAgentReady";
NSString * const kGoNativeCoreDeviceDidShake = @"co.median.ios.deviceDidShake";
NSString * const kLEANAppConfigNotificationProcessedWebViewPools = @"co.median.ios.AppConfig.processedWebViewPools";
NSString * const kLEANAppConfigNotificationProcessedMenu = @"co.median.ios.AppConfig.processedMenu";
NSString * const kLEANAppConfigNotificationProcessedSegmented = @"co.median.ios.AppConfig.processedSegmented";
NSString * const kLEANAppConfigNotificationProcessedTabNavigation = @"co.median.ios.AppConfig.processedTabNavigation";
NSString * const kLEANAppConfigNotificationProcessedNavigationTitles = @"co.median.ios.AppConfig.processedNavigationTitles";
NSString * const kLEANAppConfigNotificationProcessedNavigationLevels = @"co.median.ios.AppConfig.processedNavigationLevels";
NSString * const kLEANAppConfigNotificationAppTrackingStatusChanged = @"co.median.ios.AppConfig.appTrackingStatusChanged";

// RegexEnabled implementation
@implementation RegexEnabled
@end

// LEANIcons stub implementation
@implementation LEANIcons
+ (UIImage *)imageForIconIdentifier:(NSString *)identifier size:(CGFloat)size color:(UIColor *)color {
    return nil; // No-op stub
}
@end

// WebViewViewportManager stub implementation
@implementation WebViewViewportManager
- (instancetype)initWithWebView:(id)webView config:(id)config {
    return [super init];
}
@end


// NSAttributedString+GNIcons stub
@implementation NSAttributedString (GNIcons)
- (instancetype)initWithIconName:(NSString *)iconName color:(UIColor *)color size:(CGFloat)size {
    return [self initWithString:iconName];
}
@end

// CustomMenu stub implementation
@implementation CustomMenu
- (instancetype)initWithContainer:(UIView *)container button:(UIView *)button data:(NSArray *)data onTap:(CustomMenuTapBlock)onTap {
    return [super init];
}
- (void)dismiss {}
@end

// WindowsController stub
@implementation WindowsController
+ (void)windowCountChanged {}
@end
