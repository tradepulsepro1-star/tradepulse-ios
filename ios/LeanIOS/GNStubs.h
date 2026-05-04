// GNStubs.h - Complete stub declarations for GoNativeCore
// Auto-included via OTHER_CFLAGS for TradePulse ObjC target only
#pragma once

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
@property (nonatomic) CGFloat menuAnimationDuration;
// Tabs
@property (nonatomic, strong) NSDictionary *tabMenus;
@property (nonatomic, strong) NSArray *tabMenuRegexes;
@property (nonatomic, strong) NSArray *tabMenuIDs;
@property (nonatomic) BOOL hideTabBarOnScroll;
// Toolbar
@property (nonatomic) BOOL toolbarEnabled;
@property (nonatomic, strong) NSArray *toolbarItems;
@property (nonatomic, strong) NSArray *toolbarRegexes;
@property (nonatomic, strong) NSArray *toolbarVisibilityByPages;
@property (nonatomic, strong) NSArray *toolbarVisibilityByBackButton;
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
@property (nonatomic) BOOL hideWebviewAlpha;
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
@property (nonatomic, strong) NSArray *listeners;
// Actions / Menus
@property (nonatomic, strong) NSDictionary *actions;
@property (nonatomic, strong) NSDictionary *actionSelection;
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
extern NSString * const kLEANWebViewPoolDisownPolicyDefault;

// RegexEnabled stub - used by LEANToolbarManager
@interface RegexEnabled : NSObject
@property (nonatomic, strong) NSPredicate *regex;
@property (nonatomic) BOOL enabled;
@end

// LEANIcons stub - used by toolbar/tab managers
@interface LEANIcons : NSObject
+ (UIImage *)imageForIconIdentifier:(NSString *)identifier size:(CGFloat)size color:(UIColor *)color;
@end

// GNJavascriptRunner protocol - used by LEANWebViewController
@protocol GNJavascriptRunner <NSObject>
- (void)runJavascript:(NSString *)js;
- (void)runJavascriptWithCallback:(id)callback data:(NSDictionary *)data;
@end

// WebViewViewportManager stub - used by LEANWebViewController
@interface WebViewViewportManager : NSObject
- (instancetype)initWithWebView:(id)webView config:(id)config;
@end


// NSAttributedString icon category (was part of GoNativeCore)
@interface NSAttributedString (GNIcons)
- (instancetype)initWithIconName:(NSString *)iconName color:(UIColor *)color size:(CGFloat)size;
@end


// Helper macro for iOS 15+ key window access
static inline UIWindow* GNKeyWindow(void) {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *w in ((UIWindowScene *)scene).windows) {
                if (w.isKeyWindow) return w;
            }
        }
    }
    return [UIApplication sharedApplication].windows.firstObject;
}
#define currentKeyWindow_REMOVED_USE_GNKeyWindow 1


// GNBridge stubs
@interface GNBridgeController : NSObject
- (void)triggerEvent:(NSString *)event;
- (void)triggerEvent:(NSString *)event data:(id)data;
@end

@interface GNBridge : NSObject
- (GNBridgeController *)getControllerForKey:(NSString *)key runner:(id)runner;
@end

#endif // __OBJC__
