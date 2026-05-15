// GoNativeCoreStub.m - Stub implementations for GoNativeCore linker symbols
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

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

@implementation GNBridge @end

@implementation GNJSBridgeHandler
+ (instancetype)shared {
    static GNJSBridgeHandler *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GNJSBridgeHandler alloc] init]; }); return i;
}
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc {}
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

// GNBridge full implementation - satisfies all linker references from LeanIOS files
@interface GNBridge (BridgeMethods)
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options;
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)runnerDidLoad:(id)runner;
- (void)runnerWillAppear:(id)runner;
- (void)runnerWillDisappear:(id)runner;
- (void)runner:(id)runner willTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator;
- (BOOL)runner:(id)runner shouldLoadRequestWithURL:(NSURL *)url withData:(NSDictionary *)data;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation withRunner:(id)runner;
- (void)webView:(WKWebView *)webView handleURL:(NSURL *)url;
- (BOOL)webView:(WKWebView *)webView shouldDownloadUrl:(NSURL *)url;
- (void)switchToWebView:(WKWebView *)webView withRunner:(id)runner;
- (void)hideWebViewWithRunner:(id)runner;
- (void)loadUserScriptsForContentController:(id)contentController;
- (NSArray *)getInitialUrlQueryItems;
- (id)getControllerForKey:(NSString *)key runner:(id)runner;
@end

@implementation GNBridge (BridgeMethods)
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
- (id)getControllerForKey:(NSString *)key runner:(id)runner { return nil; }
@end

// Missing extern constants — defined here to satisfy linker
NSString * GNFileWriterSharerName = @"gonative_file_writer_sharer";
NSUInteger GNFileWriterSharerMaxSize = 10 * 1024 * 1024; // 10MB
NSString * GNJSBridgeName = @"gonative";
NSString *kLEANLoginManagerNotificationName = @"kLEANLoginManagerNotification";
NSString *kLEANLoginManagerStatusChangedNotification = @"kLEANLoginManagerStatusChangedNotification";

// kLEANWebViewPoolDisownPolicyDefault — defined as LEANWebViewPoolDisownPolicyNever (2)
// Must match LEANWebViewPool.h enum: Always=0, Reload=1, Never=2
// kLEANWebViewPoolDisownPolicyDefault — type must match LEANWebViewPool.h NS_ENUM (NSInteger)
NSInteger kLEANWebViewPoolDisownPolicyDefault = 2; // LEANWebViewPoolDisownPolicyNever
