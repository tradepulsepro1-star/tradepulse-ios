//
// GNStubsImpl.m - Implementations for GoNativeCore stubs
//

#import "GNStubs.h"
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



// NSAttributedString+GNIcons stub
@implementation NSAttributedString (GNIcons)
- (instancetype)initWithIconName:(NSString *)iconName color:(UIColor *)color size:(CGFloat)size {
    return [self initWithString:iconName];
}
@end




// ActionSelection stub
@implementation ActionSelection
@end


// GoNativeAppConfig main implementation
@implementation GoNativeAppConfig
+ (instancetype)sharedAppConfig {
    static GoNativeAppConfig *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[self alloc] init]; }); return i;
}
+ (instancetype)shared { return [self sharedAppConfig]; }
- (NSString *)userAgentForUrl:(NSURL *)url { return @""; }
- (NSDictionary *)getRegexRuleForURL:(NSString *)url rules:(id)rules { return nil; }
- (void)initializeRegexRules:(id *)rules {}
- (void)setNewRegexRules:(id)rules regexRulesArray:(id *)array {}
@end

// GoNativeAppConfig sidebar extras
@implementation GoNativeAppConfig (SidebarExtras)
- (BOOL)shouldShowSidebarForUrl:(NSString *)url {
    return YES;
}
@end

// GNJSBridgeHandler stub
@implementation GNJSBridgeHandler
+ (instancetype)shared {
    static GNJSBridgeHandler *s; static dispatch_once_t t; dispatch_once(&t, ^{ s = [self new]; }); return s;
}
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc {}
@end

// GNUtilities stub
@implementation GNUtilities
+ (BOOL)url:(NSString *)url matchesUrl:(NSString *)pattern { return NO; }
@end

// GNEventEmitter stub
@implementation GNEventEmitter
+ (instancetype)shared {
    static GNEventEmitter *s; static dispatch_once_t t; dispatch_once(&t, ^{ s = [self new]; }); return s;
}
- (void)emitEvent:(NSString *)event data:(id)data {}
@end


// UIImage MedianIcons stub
@implementation UIImage (MedianIcons)
+ (UIImage *)imageWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color { return nil; }
@end

// CustomMenu stub implementation
@implementation CustomMenu
- (instancetype)initWithContainer:(UIView *)container button:(UIButton *)button data:(NSArray *)data onTap:(CustomMenuTapHandler)onTap {
    return [super init];
}
- (void)dismiss {}
- (void)setMenuColor:(UIColor *)color {}
- (void)removeFromSuperview {}
@end

// GNBridge stub implementation
@implementation GNBridge
- (void)loadUserScriptsForContentController:(id)contentController {}
- (id<GNController>)getControllerForKey:(NSString *)key runner:(id)runner { return nil; }
@end

// GNController default implementation (protocol — no @implementation needed)

// WindowsController stub implementation
@implementation WindowsController
+ (void)windowCountChanged {}
@end

// ContextMenuHandler stub implementation
@implementation ContextMenuHandler
+ (UIContextMenuConfiguration *)createConfigurationWithUrl:(NSURL *)url shareAction:(dispatch_block_t)shareAction {
    return nil;
}
@end

// LEANLiquidTitleView stub implementation
@implementation LEANLiquidTitleView
@end

