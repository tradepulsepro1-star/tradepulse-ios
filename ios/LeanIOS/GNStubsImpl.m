//
// GNStubsImpl.m - Implementations for GoNativeCore stubs
// Reads appConfig.json at startup so initialURL and userAgentReady are populated.
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
        self.hideWebviewAlpha = @(0.0);
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
        self.hideWebviewAlpha = @(0.0);
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
        self.hideWebviewAlpha = @(0.0);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
        });
        return;
    }

    // Parse initialUrl
    NSString *urlStr = json[@"initialUrl"];
    if (urlStr && urlStr.length > 0) {
        self.initialURL = [NSURL URLWithString:urlStr];
    } else {
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
    }

    // Parse appName
    NSString *name = json[@"appName"];
    self.appName = (name && name.length > 0) ? name : @"TradePulse";

    // Parse iosTheme
    NSDictionary *ios = json[@"ios"];
    NSDictionary *appearance = ios[@"appearance"];
    NSString *theme = appearance[@"theme"];
    self.iosTheme = (theme && theme.length > 0) ? theme : @"dark";

    // Navigation
    NSDictionary *navDict = json[@"navigationLevels"] ?: json[@"navigation"];
    self.showNavigationBar = [json[@"navigationEnabled"] boolValue];
    self.showNavigationMenu = [json[@"sidebarEnabled"] boolValue];
    self.navTitles = json[@"navigationTitles"] ?: @[];

    // Misc
    self.swipeGestures = (json[@"swipeGestures"] != nil) ? [json[@"swipeGestures"] boolValue] : YES;
    self.showKeyboardAccessoryView = [json[@"showKeyboardAccessoryView"] boolValue];
    self.keepScreenOn = [json[@"keepScreenOn"] boolValue];
    self.iosEnableOverlayInStatusBar = [ios[@"statusBar"][@"overlay"] boolValue];
    self.hideWebviewAlpha = json[@"hideWebviewAlpha"] ?: @(0.0);
    self.profilePickerJS = json[@"profilePickerJS"];
    self.registrationEndpoints = json[@"registrationEndpoints"];

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
