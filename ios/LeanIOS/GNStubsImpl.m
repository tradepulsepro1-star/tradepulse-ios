//
// GNStubsImpl.m - Implementations for GoNativeCore stubs
// Reads appConfig.json at startup so initialURL and userAgentReady are populated.
//

#import "GNStubs.h"
#import "LEANWebViewPool.h"
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

// Missing GoNativeCore constants — defined here since we don't link GoNativeCore.framework
NSString * GNJSBridgeName = @"gonative";
NSString * GNFileWriterSharerName = @"gonativeFileWriterSharer";
NSUInteger GNFileWriterSharerMaxSize = 10 * 1024 * 1024; // 10 MB

// Missing LEAN constants
NSString * kLEANLoginManagerNotificationName = @"co.median.ios.loginManager.notification";
NSString * kLEANLoginManagerStatusChangedNotification = @"co.median.ios.loginManager.statusChanged";
LEANWebViewPoolDisownPolicy kLEANWebViewPoolDisownPolicyDefault = LEANWebViewPoolDisownPolicyReload;

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
    static GoNativeAppConfig *i;
    static dispatch_once_t t;
    dispatch_once(&t, ^{
        i = [[self alloc] init];
        [i loadFromAppConfig];
    });
    return i;
}

+ (instancetype)shared { return [self sharedAppConfig]; }

- (void)loadFromAppConfig {
    // Read appConfig.json from the main bundle
    NSString *configPath = [[NSBundle mainBundle] pathForResource:@"appConfig" ofType:@"json"];
    if (!configPath) {
        // Fallback: set the live app URL directly so the WebView always loads
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
        self.appName = @"TradePulse";
        self.iosTheme = @"dark";
        self.userAgentReady = YES;
        self.showNavigationBar = NO;
        self.showNavigationMenu = NO;
        self.swipeGestures = YES;
        self.showKeyboardAccessoryView = NO;
        self.keepScreenOn = NO;
        self.iosEnableOverlayInStatusBar = NO;
        self.navTitles = @[];
        self.hideWebviewAlpha = @(1.0);
        // Fire ready notification
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
        });
        return;
    }

    NSData *data = [NSData dataWithContentsOfFile:configPath];
    if (!data) {
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
        self.userAgentReady = YES;
        self.appName = @"TradePulse";
        self.iosTheme = @"dark";
        self.showNavigationBar = NO;
        self.showNavigationMenu = NO;
        self.swipeGestures = YES;
        self.showKeyboardAccessoryView = NO;
        self.keepScreenOn = NO;
        self.iosEnableOverlayInStatusBar = NO;
        self.navTitles = @[];
        self.hideWebviewAlpha = @(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
        });
        return;
    }

    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || !json) {
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
        self.userAgentReady = YES;
        self.appName = @"TradePulse";
        self.iosTheme = @"dark";
        self.showNavigationBar = NO;
        self.showNavigationMenu = NO;
        self.swipeGestures = YES;
        self.showKeyboardAccessoryView = NO;
        self.keepScreenOn = NO;
        self.iosEnableOverlayInStatusBar = NO;
        self.navTitles = @[];
        self.hideWebviewAlpha = @(1.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
        });
        return;
    }

    // appConfig.json is nested: general / navigation / styling sections
    NSDictionary *general  = [json[@"general"]  isKindOfClass:[NSDictionary class]] ? json[@"general"]  : @{};
    NSDictionary *nav      = [json[@"navigation"] isKindOfClass:[NSDictionary class]] ? json[@"navigation"] : @{};
    NSDictionary *styling  = [json[@"styling"]  isKindOfClass:[NSDictionary class]] ? json[@"styling"]  : @{};

    // initialUrl — under "general"
    NSString *urlStr = [general[@"initialUrl"] isKindOfClass:[NSString class]] ? general[@"initialUrl"] : nil;
    if (urlStr && urlStr.length > 0) {
        self.initialURL = [NSURL URLWithString:urlStr];
    } else {
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
    }

    // appName — under "general"
    NSString *name = [general[@"appName"] isKindOfClass:[NSString class]] ? general[@"appName"] : nil;
    self.appName = (name && name.length > 0) ? name : @"TradePulse";

    // iosTheme — under "styling"
    NSString *theme = [styling[@"iosTheme"] isKindOfClass:[NSString class]] ? styling[@"iosTheme"] : nil;
    self.iosTheme = (theme && theme.length > 0) ? theme : @"dark";

    // Navigation bar / menu — under "styling"
    self.showNavigationBar = [styling[@"showNavigationBar"] boolValue];
    self.showNavigationMenu = NO; // sidebar not used

    // Nav titles — under "navigation" -> "navigationTitles" -> "titles"
    NSDictionary *navTitlesDict = [nav[@"navigationTitles"] isKindOfClass:[NSDictionary class]] ? nav[@"navigationTitles"] : @{};
    self.navTitles = [navTitlesDict[@"titles"] isKindOfClass:[NSArray class]] ? navTitlesDict[@"titles"] : @[];

    // Swipe gestures — under "navigation", nil = YES default
    self.swipeGestures = (nav[@"swipeGestures"] != nil && nav[@"swipeGestures"] != [NSNull null])
        ? [nav[@"swipeGestures"] boolValue] : YES;

    // keepScreenOn — under "general"
    self.keepScreenOn = [general[@"keepScreenOn"] boolValue];

    // Status bar overlay — under "styling"
    self.iosEnableOverlayInStatusBar = [styling[@"iosEnableOverlayInStatusBar"] boolValue];

    // CRITICAL: hideWebviewAlpha — under "styling" — must be 1.0 so WebView is VISIBLE
    id alphaVal = styling[@"hideWebviewAlpha"];
    self.hideWebviewAlpha = (alphaVal && alphaVal != [NSNull null]) ? alphaVal : @(1.0);

    // Keyboard, profilePickerJS, registrationEndpoints — not in appConfig, use safe defaults
    self.showKeyboardAccessoryView = NO;
    self.profilePickerJS = nil;
    self.registrationEndpoints = nil;

    // Mark ready and fire notification
    self.userAgentReady = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
    });
}

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

// GNBridge stub implementation
@implementation GNBridge
- (void)loadUserScriptsForContentController:(id)contentController {}
- (id<GNController>)getControllerForKey:(NSString *)key runner:(id)runner { return nil; }
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options { return NO; }
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity { return NO; }
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {}
@end
