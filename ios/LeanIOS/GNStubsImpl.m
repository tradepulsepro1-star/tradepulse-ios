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
        self.hideWebviewAlpha = @(1.0);
        self.initialHost = @"tradepulsepro.net";
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
        self.initialHost = @"tradepulsepro.net";
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
        self.initialHost = @"tradepulsepro.net";
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kGoNativeAppConfigNotificationUserAgentReady object:nil];
        });
        return;
    }

    // Parse sections
    NSDictionary *general = ([json[@"general"] isKindOfClass:[NSDictionary class]] ? json[@"general"] : @{});
    NSDictionary *styling = ([json[@"styling"] isKindOfClass:[NSDictionary class]] ? json[@"styling"] : @{});
    NSDictionary *navigation = ([json[@"navigation"] isKindOfClass:[NSDictionary class]] ? json[@"navigation"] : @{});

    // Parse initialUrl (nested under "general")
    NSString *urlStr = general[@"initialUrl"];
    if (urlStr && [urlStr isKindOfClass:[NSString class]] && urlStr.length > 0) {
        self.initialURL = [NSURL URLWithString:urlStr];
    } else {
        self.initialURL = [NSURL URLWithString:@"https://tradepulsepro.net"];
    }

    // Parse appName
    NSString *name = general[@"appName"];
    self.appName = (name && [name isKindOfClass:[NSString class]] && name.length > 0) ? name : @"TradePulse";

    // Parse iosTheme (from styling)
    NSString *theme = ([styling[@"iosTheme"] isKindOfClass:[NSString class]] ? styling[@"iosTheme"] : nil);
    self.iosTheme = (theme && theme.length > 0) ? theme : @"dark";

    // Navigation
    self.showNavigationBar = [styling[@"showNavigationBar"] boolValue];
    self.showNavigationMenu = NO;
    self.navTitles = @[];

    // Misc
    self.swipeGestures = YES;
    self.showKeyboardAccessoryView = NO;
    self.keepScreenOn = [general[@"keepScreenOn"] boolValue];
    self.iosEnableOverlayInStatusBar = NO;
    // ALWAYS force hideWebviewAlpha = 1.0 — never let JSON set it lower (causes black screen)
    self.hideWebviewAlpha = @(1.0);
    self.profilePickerJS = nil;
    self.registrationEndpoints = nil;

    // Set initialHost from initialURL
    self.initialHost = self.initialURL.host ?: @"tradepulsepro.net";

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

// GNBridge stub implementation — all lifecycle methods are no-ops
@implementation GNBridge
// App lifecycle
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options { return NO; }
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity { return NO; }
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {}
// Runner lifecycle
- (void)runnerDidLoad:(id)runner {}
- (void)runnerWillAppear:(id)runner {}
- (void)runnerWillDisappear:(id)runner {}
- (void)runner:(id)runner willTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {}
- (BOOL)runner:(id)runner shouldLoadRequestWithURL:(NSURL *)url withData:(NSDictionary *)data { return YES; }
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation withRunner:(id)runner {}
- (void)webView:(WKWebView *)webView handleURL:(NSURL *)url {}
- (BOOL)webView:(WKWebView *)webView shouldDownloadUrl:(NSURL *)url { return NO; }
- (void)switchToWebView:(WKWebView *)webView withRunner:(id)runner {}
- (void)hideWebViewWithRunner:(id)runner {}
- (void)loadUserScriptsForContentController:(id)contentController {}
- (NSArray *)getInitialUrlQueryItems { return @[]; }
- (id<GNController>)getControllerForKey:(NSString *)key runner:(id)runner { return nil; }
@end
