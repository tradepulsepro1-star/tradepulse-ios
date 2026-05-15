// GNStubs.h - Complete stub declarations for GoNativeCore
// Auto-included via OTHER_CFLAGS for TradePulse ObjC target only
#pragma once

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Median event listener key constants (removed from SDK — defined here as stubs)
#ifndef MEDIAN_KEYBOARD_EVENT_LISTENER
#define MEDIAN_KEYBOARD_EVENT_LISTENER @"median.keyboard"
#endif
#import <WebKit/WebKit.h>

#ifndef GoNativeAppConfig_DEFINED
#define GoNativeAppConfig_DEFINED



@interface GoNativeAppConfig : NSObject
+ (instancetype)sharedAppConfig;
+ (instancetype)shared;
// Core
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *configError;
@property (nonatomic, strong) NSURL *initialURL;
@property (nonatomic, strong) NSString *initialHost;
@property (nonatomic, strong) NSURL *loginURL;
@property (nonatomic, strong) NSURL *signupURL;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *appName;
// Display
@property (nonatomic, strong) NSString *stringViewport;
@property (nonatomic, strong) NSNumber *forceViewportWidth;
@property (nonatomic, strong) UIImage *navigationTitleIcon;
@property (nonatomic, strong) UIImage *appIcon;
@property (nonatomic) BOOL isNavigationTitleImage;
@property (nonatomic, strong) NSString *iosStatusBarStyle;
@property (nonatomic, strong) NSString *iosTheme;
@property (nonatomic, strong) NSString *iosDarkMode;
@property (nonatomic) BOOL iosEnableBlurInStatusBar;
@property (nonatomic) BOOL iosEnableOverlayInStatusBar;
@property (nonatomic) BOOL iosFullScreenWebview;
@property (nonatomic) BOOL iosAutoHideHomeIndicator;
// Navigation
@property (nonatomic, strong) NSArray *navStructureLevels;
@property (nonatomic, strong) NSArray *navTitles;
@property (nonatomic) BOOL showNavigationBar;
@property (nonatomic) BOOL showNavigationMenu;
@property (nonatomic) BOOL hideNavBarOnScroll;
@property (nonatomic) BOOL transparentNavBar;
@property (nonatomic, strong) NSString *sidebarMenuIcon;
@property (nonatomic, strong) NSString *sidebarIcon;
@property (nonatomic, strong) NSDictionary *sidebar;
@property (nonatomic, strong) NSString *iosSidebarFont;
@property (nonatomic, strong) NSNumber *menuAnimationDuration;
// Tabs
@property (nonatomic, strong) NSDictionary *tabMenus;
@property (nonatomic, strong) NSArray *tabMenuRegexes;
@property (nonatomic, strong) NSArray *tabMenuIDs;
@property (nonatomic) BOOL hideTabBarOnScroll;
// Toolbar
@property (nonatomic) BOOL toolbarEnabled;
@property (nonatomic, strong) NSArray *toolbarItems;
@property (nonatomic, strong) NSArray *toolbarRegexes;
@property (nonatomic) NSInteger toolbarVisibilityByPages;
@property (nonatomic) NSInteger toolbarVisibilityByBackButton;
@property (nonatomic) BOOL showToolbar;
@property (nonatomic) BOOL showShareButton;
@property (nonatomic) BOOL showKeyboardAccessoryView;
// Behavior
@property (nonatomic) BOOL keepScreenOn;
@property (nonatomic) BOOL pullToRefresh;
@property (nonatomic) BOOL pinchToZoom;
@property (nonatomic) BOOL disableAnimations;
@property (nonatomic) BOOL enableWindowOpen;
@property (nonatomic) BOOL windowOpenHideNavbar;
@property (nonatomic) BOOL useWebpageTitle;
@property (nonatomic, strong) NSNumber *hideWebviewAlpha;
@property (nonatomic) BOOL dynamicTypeEnabled;
@property (nonatomic) BOOL swipeGestures;
@property (nonatomic) NSUInteger maxWindows;
@property (nonatomic) BOOL maxWindowsAutoClose;
@property (nonatomic, strong) NSNumber *interactiveDelay;
@property (nonatomic, strong) NSNumber *iosConnectionOfflineTime;
@property (nonatomic) NSUInteger forceSessionCookieExpiry;
@property (nonatomic) CGFloat initialWebviewZoom;
// JavaScript / CSS
@property (nonatomic) BOOL hasCustomJS;
@property (nonatomic) BOOL hasCustomCSS;
@property (nonatomic) BOOL hasIosCustomJS;
@property (nonatomic) BOOL hasIosCustomCSS;
@property (nonatomic, strong) NSString *postLoadJavascript;
@property (nonatomic, strong) NSString *profilePickerJS;
@property (nonatomic) BOOL injectMedianJS;
@property (nonatomic) BOOL enableWebConsoleLogs;
@property (nonatomic) BOOL disableEventRecorder;
// Login / Auth
@property (nonatomic, strong) NSURL *loginDetectionURL;
@property (nonatomic, strong) NSArray *loginDetectRegexes;
@property (nonatomic, strong) NSArray *loginDetectLocations;
@property (nonatomic, strong) NSString *userIdRegex;
// Network
@property (nonatomic, strong) NSDictionary *customHeaders;
@property (nonatomic, strong) NSArray *redirects;
@property (nonatomic, strong) NSArray *replaceStrings;
@property (nonatomic, strong) NSArray *webviewPools;
@property (nonatomic) BOOL useWKWebView;
@property (nonatomic) BOOL iosShowOfflinePage;
// Registration / Analytics
@property (nonatomic, strong) NSArray *registrationEndpoints;
@property (nonatomic) BOOL facebookEnabled;
@property (nonatomic) BOOL iOSRequestATTConsentOnLoad;
@property (nonatomic) BOOL userAgentReady;
@property (nonatomic, strong) NSArray *nativeBridgeUrls;
@property (nonatomic, strong) NSDictionary *listeners;
// Actions / Menus
@property (nonatomic, strong) NSDictionary *actions;
@property (nonatomic, strong) NSArray *actionSelection;
@property (nonatomic, strong) NSDictionary *menus;
@property (nonatomic, strong) NSArray *segmentedControlItems;
@property (nonatomic, strong) NSArray *contextMenuLinkActions;
@property (nonatomic) BOOL contextMenuEnabled;
@property (nonatomic) BOOL disableDocumentOpenWith;
// Misc
@property (nonatomic, strong) NSDictionary *permissions;
@property (nonatomic, strong) NSDictionary *styleConfig;
- (NSString *)userAgentForUrl:(NSURL *)url;
- (NSDictionary *)getRegexRuleForURL:(NSString *)url rules:(id)rules;
- (void)initializeRegexRules:(id *)rules;
- (void)setNewRegexRules:(id)rules regexRulesArray:(id *)array;
- (BOOL)shouldShowSidebarForUrl:(NSString *)url;
@end


#endif // GoNativeAppConfig_DEFINED
// Notification constants
extern NSString * const kGoNativeAppConfigNotificationUserAgentReady;
extern NSString * const kGoNativeCoreDeviceDidShake;
extern NSString * const kLEANAppConfigNotificationProcessedWebViewPools;
extern NSString * const kLEANAppConfigNotificationProcessedMenu;
extern NSString * const kLEANAppConfigNotificationProcessedSegmented;
extern NSString * const kLEANAppConfigNotificationProcessedTabNavigation;
extern NSString * const kLEANAppConfigNotificationProcessedNavigationTitles;
extern NSString * const kLEANAppConfigNotificationProcessedNavigationLevels;
extern NSString * const kLEANAppConfigNotificationAppTrackingStatusChanged;

// LEANToolbar visibility constants (from GoNativeCore)
typedef NS_ENUM(NSInteger, LEANToolbarVisibilityByPages) {
    LEANToolbarVisibilityByPagesAlways = 0,
    LEANToolbarVisibilityByPagesSpecific = 1,
    LEANToolbarVisibilityByPagesNever = 2
};
typedef NS_ENUM(NSInteger, LEANToolbarVisibilityByBackButton) {
    LEANToolbarVisibilityByBackButtonAlways = 0,
    LEANToolbarVisibilityByBackButtonActive = 1
};

// RegexEnabled stub - used by LEANToolbarManager
@interface RegexEnabled : NSObject
@property (nonatomic, strong) NSPredicate *regex;
@property (nonatomic) BOOL enabled;
@end

// GNJavascriptRunner protocol - used by LEANWebViewController
@protocol GNJavascriptRunner <NSObject>
- (void)runJavascript:(NSString *)js;
- (void)runJavascriptWithCallback:(id)callback data:(NSDictionary *)data;
@end



// NSAttributedString icon category (was part of GoNativeCore)
@interface NSAttributedString (GNIcons)
- (instancetype)initWithIconName:(NSString *)iconName color:(UIColor *)color size:(CGFloat)size;
@end


// Helper macro for iOS 15+ key window access
// Safe for early launch — falls back through multiple strategies to avoid nil crashes
static inline UIWindow* GNKeyWindow(void) {
    // Strategy 1: foreground active scene with key window
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                if (w.isKeyWindow) return w;
            }
        }
    }
    // Strategy 2: any scene, any key window
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                if (w.isKeyWindow) return w;
            }
        }
    }
    // Strategy 3: any scene, first window
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindow *w = ((UIWindowScene *)scene).windows.firstObject;
            if (w) return w;
        }
    }
    // Strategy 4: legacy fallback
    return [UIApplication sharedApplication].windows.firstObject;
}






// ActionSelection stub — used by GoNativeAppConfig.actionSelection
@interface ActionSelection : NSObject
@property (nonatomic, strong) NSPredicate *regex;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) BOOL enabled;
@end

// GNController protocol — used by GNBridge
@protocol GNController <NSObject>
@optional
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query;
@end

// GNBridge stub — GoNative internal bridge removed
#ifndef GNBridge_DEFINED
#define GNBridge_DEFINED
@interface GNBridge : NSObject
// App lifecycle — called from LEANAppDelegate
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
// Runner lifecycle
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
#endif








// GNJSBridgeHandler stub — handles JS bridge URL navigation
@interface GNJSBridgeHandler : NSObject
+ (instancetype)shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc;
@end

// GNUtilities stub — URL matching utilities
@interface GNUtilities : NSObject
+ (BOOL)url:(NSString *)url matchesUrl:(NSString *)pattern;
@end

// GNEventEmitter stub — event broadcasting
@interface GNEventEmitter : NSObject
+ (instancetype)shared;
- (void)emitEvent:(NSString *)event data:(id)data;
@end

#endif // __OBJC__

