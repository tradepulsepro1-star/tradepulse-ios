//
// GNStubsImpl.m - Implementations for GoNativeCore stubs
//

#import "GNStubs.h"
#import "GonativeIO-Swift.h"
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

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
+ (instancetype)shared {
    static WebViewViewportManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ instance = [[self alloc] init]; });
    return instance;
}
- (instancetype)initWithWebView:(id)webView config:(id)config {
    return [super init];
}
- (void)setViewportWithScale:(CGFloat)scale width:(CGFloat)width webView:(WKWebView *)webView {}
- (void)updateViewport {}
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
    return [super initWithFrame:CGRectZero];
}
- (void)setMenuColor:(UIColor *)color {}
- (void)dismiss {}
@end

// WindowsController stub
@implementation WindowsController
+ (void)windowCountChanged {}
@end

// GNSwiftUtilities stub
@implementation GNSwiftUtilities
+ (NSString *)deviceTokenWithData:(NSData *)data {
    if (!data) return @"";
    const unsigned char *bytes = (const unsigned char *)[data bytes];
    NSMutableString *hex = [NSMutableString stringWithCapacity:data.length * 2];
    for (NSUInteger i = 0; i < data.length; i++) {
        [hex appendFormat:@"%02x", bytes[i]];
    }
    return hex;
}
@end

// ActionSelection stub
@implementation ActionSelection
@end

// GoNativeAppConfig sidebar extras
@implementation GoNativeAppConfig (SidebarExtras)
- (BOOL)shouldShowSidebarForUrl:(NSString *)url {
    return YES;
}
@end
