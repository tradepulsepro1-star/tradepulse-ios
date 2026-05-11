// GoNativeAppConfig.h — Stub header replacing private GoNativeCore SPM package
// All real implementations are compiled into the app via the LeanIOS source files.

#ifndef GoNativeAppConfig_h
#define GoNativeAppConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoNativeAppConfig : NSObject

+ (instancetype)sharedAppConfig;

// Navigation & URL
@property (nonatomic, strong, nullable) NSURL *initialURL;
@property (nonatomic, strong, nullable) NSURL *loginDetectionURL;
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
@property (nonatomic, assign) BOOL dynamicTypeEnabled;
@property (nonatomic, assign) BOOL pinchToZoom;
@property (nonatomic, assign) BOOL disableAnimations;
@property (nonatomic, strong, nullable) NSNumber *forceViewportWidth;
@property (nonatomic, copy, nullable) NSString *stringViewport;
@property (nonatomic, strong, nullable) NSNumber *interactiveDelay;
@property (nonatomic, strong, nullable) NSNumber *iosConnectionOfflineTime;
@property (nonatomic, assign) BOOL iosShowOfflinePage;
@property (nonatomic, assign) NSUInteger forceSessionCookieExpiry;

// UI & Appearance
@property (nonatomic, copy, nullable) NSString *iosTheme;
@property (nonatomic, strong, nullable) UIImage *navigationTitleIcon;
@property (nonatomic, strong, nullable) UIImage *sidebarIcon;
@property (nonatomic, strong, nullable) UIImage *appIcon;
@property (nonatomic, copy, nullable) NSString *sidebarMenuIcon;
@property (nonatomic, strong, nullable) UIFont *iosSidebarFont;
@property (nonatomic, copy, nullable) NSString *appName;
@property (nonatomic, assign) BOOL showShareButton;
@property (nonatomic, assign) BOOL showToolbar;
@property (nonatomic, assign) BOOL iosAutoHideHomeIndicator;

// Navigation structures
@property (nonatomic, strong, nullable) NSArray *navStructureLevels;
@property (nonatomic, strong, nullable) NSArray *navTitles;
@property (nonatomic, strong, nullable) NSDictionary *menus;
@property (nonatomic, strong, nullable) NSArray *tabMenuIDs;
@property (nonatomic, strong, nullable) NSArray *tabMenuRegexes;
@property (nonatomic, strong, nullable) NSDictionary *tabMenus;
@property (nonatomic, strong, nullable) NSArray *toolbarItems;
@property (nonatomic, strong, nullable) NSArray *segmentedControlItems;
@property (nonatomic, strong, nullable) NSArray *actions;

// Login / Auth
@property (nonatomic, strong, nullable) NSArray *loginDetectRegexes;
@property (nonatomic, strong, nullable) NSArray *loginDetectLocations;

// Webview pools
@property (nonatomic, strong, nullable) NSArray *webviewPools;

// Replace strings
@property (nonatomic, strong, nullable) NSArray *replaceStrings;

// Listeners
@property (nonatomic, strong, nullable) NSDictionary *listeners;

// Misc
@property (nonatomic, assign) BOOL injectMedianJS;
@property (nonatomic, assign) BOOL disableEventRecorder;
@property (nonatomic, copy, nullable) NSString *publicKey;
@property (nonatomic, copy, nullable) NSString *userIdRegex;
@property (nonatomic, strong, nullable) NSDictionary *customHeaders;

// Regex rules
@property (nonatomic, strong, nullable) NSArray<NSDictionary *> *regexRules;
- (void)initializeRegexRules:(NSArray<NSDictionary *> * _Nullable * _Nullable)outRules;
- (void)setNewRegexRules:(NSDictionary * _Nullable)rules regexRulesArray:(NSArray<NSDictionary *> * _Nullable * _Nullable)outRules;
- (nullable NSDictionary *)getRegexRuleForURL:(nullable NSString *)urlString rules:(nullable NSArray<NSDictionary *> *)rules;

@end

NS_ASSUME_NONNULL_END

#endif /* GoNativeAppConfig_h */
