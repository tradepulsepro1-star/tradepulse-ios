// GoNativeCoreStub.m - Stub implementations for GoNativeCore linker symbols
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoNativeAppConfig : NSObject
+ (instancetype)sharedAppConfig;
+ (instancetype)shared;
@property (nonatomic) BOOL contextMenuEnabled, pinchToZoom, pullToRefresh, swipeGestures;
@property (nonatomic) BOOL dynamicTypeEnabled, disableAnimations, disableEventRecorder;
@property (nonatomic) BOOL enableWindowOpen, injectMedianJS, useWKWebView, userAgentReady;
@property (nonatomic) BOOL showShareButton, showToolbar, iosAutoHideHomeIndicator, iosShowOfflinePage;
@property (nonatomic, strong) NSArray *contextMenuLinkActions, *navStructureLevels, *navTitles;
@property (nonatomic, strong) NSArray *tabMenus, *tabMenuIDs, *tabMenuRegexes, *webviewPools;
@property (nonatomic, strong) NSArray *loginDetectRegexes, *loginDetectLocations, *menuItems;
@property (nonatomic, strong) NSArray *menus, *listeners, *toolbarItems, *segmentedControlItems, *replaceStrings;
@property (nonatomic, strong) NSDictionary *actions, *customHeaders, *font;
@property (nonatomic, strong) NSString *initialHost, *publicKey, *stringViewport, *sidebarMenuIcon;
@property (nonatomic, strong) NSString *sidebarIcon, *appName, *userAgent, *userIdRegex;
@property (nonatomic, strong) NSString *currentMenuID, *signupURL, *targetFrame, *iosTheme, *iosSidebarFont;
@property (nonatomic, strong) NSNumber *forceViewportWidth, *interactiveDelay, *iosConnectionOfflineTime;
@property (nonatomic) NSUInteger maxWindows, forceSessionCookieExpiry;
@property (nonatomic, strong) NSURL *initialURL, *loginDetectionURL;
@property (nonatomic, strong) UIImage *navigationTitleIcon, *appIcon;
@end

@implementation GoNativeAppConfig
+ (instancetype)sharedAppConfig {
    static GoNativeAppConfig *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GoNativeAppConfig alloc] init]; }); return i;
}
+ (instancetype)shared { return [self sharedAppConfig]; }
- (NSString *)userAgentForUrl:(NSURL *)url { return @""; }
- (NSDictionary *)getRegexRuleForURL:(NSString *)url rules:(id)rules { return nil; }
- (void)initializeRegexRules:(id *)rules {}
- (void)setNewRegexRules:(id)rules regexRulesArray:(id *)array {}
@end

@interface GNBridge : NSObject @end
@implementation GNBridge @end

@interface GNJSBridgeHandler : NSObject
+ (instancetype)shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc;
@end
@implementation GNJSBridgeHandler
+ (instancetype)shared {
    static GNJSBridgeHandler *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GNJSBridgeHandler alloc] init]; }); return i;
}
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc {}
@end

@interface GNEventEmitter : NSObject
+ (instancetype)shared;
- (void)emitEvent:(NSString *)event data:(id)data;
@end
@implementation GNEventEmitter
+ (instancetype)shared {
    static GNEventEmitter *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GNEventEmitter alloc] init]; }); return i;
}
- (void)emitEvent:(NSString *)event data:(id)data {}
@end

NSString * const kGoNativeAppConfigNotificationUserAgentReady = @"kGoNativeAppConfigNotificationUserAgentReady";
NSString * const kGoNativeCoreDeviceDidShake = @"kGoNativeCoreDeviceDidShake";

@implementation UIImage (MedianIcons)
+ (UIImage *)imageWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color { return nil; }
- (instancetype)initWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color { return nil; }
@end
