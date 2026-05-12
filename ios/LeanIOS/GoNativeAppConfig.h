// GoNativeAppConfig.h — Comprehensive stub replacing private GoNativeCore SPM package
// All properties referenced across LeanIOS .m files are declared here.

#ifndef GoNativeAppConfig_h
#define GoNativeAppConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoNativeAppConfig : NSObject

+ (instancetype)sharedAppConfig;
+ (nullable instancetype)shared;

// Navigation & URL
@property (nonatomic, strong, nullable) NSURL *initialURL;
@property (nonatomic, strong, nullable) NSURL *loginDetectionURL;
@property (nonatomic, strong, nullable) NSURL *loginURL;
@property (nonatomic, strong, nullable) NSURL *signupURL;
@property (nonatomic, copy, nullable) NSString *initialHost;

// User Agent
@property (nonatomic, copy, nullable) NSString *userAgent;
@property (nonatomic, assign) BOOL userAgentReady;
- (nullable NSString *)userAgentForUrl:(nullable NSURL *)url;

// WebView
@property (nonatomic, assign) BOOL useWKWebView;
@property (nonatomic, assign) BOOL pullToRefresh;
@property (nonatomic, assign) BOOL swipeGestures;
@property (nonatomic, assign) BOOL enableWindowOpen;
@property (nonatomic, assign) BOOL windowOpenHideNavbar;
@property (nonatomic, assign) BOOL enableWebConsoleLogs;
@property (nonatomic, assign) BOOL dynamicTypeEnabled;
@property (nonatomic, assign) BOOL pinchToZoom;
@property (nonatomic, assign) BOOL disableAnimations;
@property (nonatomic, assign) BOOL hideWebviewAlpha;
@property (nonatomic, assign) BOOL keepScreenOn;
@property (nonatomic, assign) BOOL disableDocumentOpenWith;
@property (nonatomic, strong, nullable) NSNumber *forceViewportWidth;
@property (nonatomic, copy, nullable) NSString *stringViewport;
@property (nonatomic, strong, nullable) NSNumber *interactiveDelay;
@property (nonatomic, strong, nullable) NSNumber *iosConnectionOfflineTime;
@property (nonatomic, assign) BOOL iosShowOfflinePage;
@property (nonatomic, assign) NSUInteger forceSessionCookieExpiry;
@property (nonatomic, copy, nullable) NSString *postLoadJavascript;

// Custom CSS / JS
@property (nonatomic, assign) BOOL hasCustomCSS;
@property (nonatomic, assign) BOOL hasCustomJS;
@property (nonatomic, assign) BOOL hasIosCustomCSS;
@property (nonatomic, assign) BOOL hasIosCustomJS;

// UI & Appearance
@property (nonatomic, copy, nullable) NSString *iosTheme;
@property (nonatomic, assign) BOOL iosDarkMode;
@property (nonatomic, assign) BOOL iosFullScreenWebview;
@property (nonatomic, assign) BOOL iosEnableBlurInStatusBar;
@property (nonatomic, assign) BOOL iosEnableOverlayInStatusBar;
@property (nonatomic, copy, nullable) NSString *iosStatusBarStyle;
@property (nonatomic, strong, nullable) UIImage *navigationTitleIcon;
@property (nonatomic, strong, nullable) UIImage *sidebarIcon;
@property (nonatomic, strong, nullable) UIImage *appIcon;
@property (nonatomic, copy, nullable) NSString *sidebarMenuIcon;
@property (nonatomic, strong, nullable) UIFont *iosSidebarFont;
@property (nonatomic, copy, nullable) NSString *appName;
@property (nonatomic, assign) BOOL showShareButton;
@property (nonatomic, assign) BOOL showToolbar;
@property (nonatomic, assign) BOOL iosAutoHideHomeIndicator;
@property (nonatomic, assign) BOOL isNavigationTitleImage;
@property (nonatomic, assign) BOOL transparentNavBar;

// Navigation bar / sidebar visibility
@property (nonatomic, assign) BOOL showNavigationBar;
@property (nonatomic, assign) BOOL showNavigationMenu;
@property (nonatomic, assign) BOOL hideNavBarOnScroll;
@property (nonatomic, assign) BOOL hideTabBarOnScroll;
@property (nonatomic, assign) BOOL showKeyboardAccessoryView;
@property (nonatomic, assign) BOOL useWebpageTitle;

// Toolbar
@property (nonatomic, assign) BOOL toolbarEnabled;
@property (nonatomic, strong, nullable) NSArray *toolbarRegexes;
@property (nonatomic, strong, nullable) NSArray *toolbarVisibilityByBackButton;
@property (nonatomic, strong, nullable) NSArray *toolbarVisibilityByPages;
@property (nonatomic, strong, nullable) NSArray *toolbarItems;

// Menu / animation
@property (nonatomic, strong, nullable) NSNumber *menuAnimationDuration;

// Navigation structures
@property (nonatomic, strong, nullable) NSArray *navStructureLevels;
@property (nonatomic, strong, nullable) NSArray *navTitles;
@property (nonatomic, strong, nullable) NSDictionary *menus;
@property (nonatomic, strong, nullable) NSArray *tabMenuIDs;
@property (nonatomic, strong, nullable) NSArray *tabMenuRegexes;
@property (nonatomic, strong, nullable) NSDictionary *tabMenus;
@property (nonatomic, strong, nullable) NSArray *segmentedControlItems;
@property (nonatomic, strong, nullable) NSArray *actions;
@property (nonatomic, strong, nullable) id actionSelection;

// Login / Auth
@property (nonatomic, strong, nullable) NSArray *loginDetectRegexes;
@property (nonatomic, strong, nullable) NSArray *loginDetectLocations;
@property (nonatomic, assign) BOOL facebookEnabled;

// Registration
@property (nonatomic, strong, nullable) NSArray *registrationEndpoints;

// Profile picker
@property (nonatomic, copy, nullable) NSString *profilePickerJS;

// Webview pools
@property (nonatomic, strong, nullable) NSArray *webviewPools;

// Replace strings / redirects
@property (nonatomic, strong, nullable) NSArray *replaceStrings;
@property (nonatomic, strong, nullable) NSArray *redirects;

// Native bridge
@property (nonatomic, strong, nullable) NSArray *nativeBridgeUrls;

// Listeners
@property (nonatomic, strong, nullable) NSDictionary *listeners;

// Misc
@property (nonatomic, assign) BOOL injectMedianJS;
@property (nonatomic, assign) BOOL disableEventRecorder;
@property (nonatomic, copy, nullable) NSString *publicKey;
@property (nonatomic, copy, nullable) NSString *userIdRegex;
@property (nonatomic, strong, nullable) NSDictionary *customHeaders;
@property (nonatomic, copy, nullable) id configError;

@// Sidebar helper
- (BOOL)shouldShowSidebarForUrl:(nullable NSString *)url;


// Additional properties used in LeanIOS
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures;
@property (nonatomic, copy, nullable) NSString *currentMenuID;
@property (nonatomic, strong, nullable) UIFont *font;
@property (nonatomic, strong, nullable) NSArray *menuItems;

// Regex rules
@property (nonatomic, strong, nullable) NSArray<NSDictionary *> *regexRules;
- (void)initializeRegexRules:(NSArray<NSDictionary *> * _Nullable * _Nullable)outRules;
- (void)setNewRegexRules:(NSDictionary * _Nullable)rules regexRulesArray:(NSArray<NSDictionary *> * _Nullable * _Nullable)outRules;
- (nullable NSDictionary *)getRegexRuleForURL:(nullable NSString *)urlString rules:(nullable NSArray<NSDictionary *> *)rules;

@end

NS_ASSUME_NONNULL_END

#endif /* GoNativeAppConfig_h */
