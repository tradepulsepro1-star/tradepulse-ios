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
NSString * const kLEANLoginManagerNotificationName = @"co.median.ios.LoginManager.notification";
NSString * const kLEANLoginManagerStatusChangedNotification = @"co.median.ios.LoginManager.statusChanged";
NSString * const kLEANWebViewControllerClearPools = @"co.median.ios.WebViewController.clearPools";
NSString * const kLEANWebViewControllerUserFinishedLoading = @"co.median.ios.WebViewController.finished";
NSString * const kLEANWebViewControllerUserStartedLoading = @"co.median.ios.WebViewController.started";
NSString * const kLEANWebViewPoolDisownPolicyDefault = @"default";

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
