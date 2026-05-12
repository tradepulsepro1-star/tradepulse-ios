//
//  GoNativeAppConfig.h — Stub replacing private GoNativeCore SPM package
//

#ifndef GoNativeAppConfig_h
#define GoNativeAppConfig_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoNativeAppConfig : NSObject

// Singleton accessors (both ObjC and Swift styles)
+ (instancetype)sharedAppConfig;

// App identity
@property (nonatomic, strong, nullable) NSString *appName;
@property (nonatomic, strong, nullable) UIImage *appIcon;
@property (nonatomic, strong, nullable) NSString *publicKey;

// Navigation & URLs
@property (nonatomic, strong, nullable) NSURL *initialURL;
@property (nonatomic, strong, nullable) NSString *initialHost;
@property (nonatomic, strong, nullable) NSString *targetFrame;
@property (nonatomic, strong, nullable) NSURL *loginDetectionURL;
@property (nonatomic, strong, nullable) NSArray *loginDetectLocations;
@property (nonatomic, strong, nullable) NSArray *loginDetectRegexes;

// WebView config
@property (nonatomic, assign) BOOL useWKWebView;
@property (nonatomic, assign) BOOL allowsBackForwardNavigationGestures;
@property (nonatomic, assign) BOOL pinchToZoom;
@property (nonatomic, assign) BOOL dynamicTypeEnabled;
@property (nonatomic, assign) BOOL enableWindowOpen;
@property (nonatomic, assign) BOOL injectMedianJS;
@property (nonatomic, assign) BOOL disableAnimations;
@property (nonatomic, assign) BOOL disableEventRecorder;
@property (nonatomic, assign) BOOL userAgentReady;
@property (nonatomic, assign) NSInteger maxWindows;
@property (nonatomic, assign) double interactiveDelay;
@property (nonatomic, assign) double forceSessionCookieExpiry;
@property (nonatomic, assign) double iosConnectionOfflineTime;
@property (nonatomic, assign) double forceViewportWidth;
@property (nonatomic, strong, nullable) NSString *stringViewport;

// iOS appearance
@property (nonatomic, strong, nullable) NSString *iosTheme;
@property (nonatomic, assign) BOOL iosAutoHideHomeIndicator;
@property (nonatomic, assign) BOOL iosShowOfflinePage;
@property (nonatomic, strong, nullable) UIFont *iosSidebarFont;
@property (nonatomic, strong, nullable) UIFont *font;
@property (nonatomic, strong, nullable) UIImage *sidebarIcon;
@property (nonatomic, strong, nullable) UIImage *sidebarMenuIcon;
@property (nonatomic, strong, nullable) UIImage *navigationTitleIcon;

// Navigation structure
@property (nonatomic, strong, nullable) NSArray *menuItems;
@property (nonatomic, strong, nullable) NSArray *navStructureLevels;
@property (nonatomic, strong, nullable) NSDictionary *navTitles;
@property (nonatomic, strong, nullable) NSDictionary *actions;
@property (nonatomic, strong, nullable) NSArray *toolbarItems;
@property (nonatomic, assign) BOOL showToolbar;
@property (nonatomic, assign) BOOL showShareButton;

// Tab & segmented control
@property (nonatomic, strong, nullable) NSArray *tabMenus;
@property (nonatomic, strong, nullable) NSArray *tabMenuRegexes;
@property (nonatomic, strong, nullable) NSArray *segmentedControlItems;

// Misc
@property (nonatomic, strong, nullable) NSDictionary *customHeaders;
@property (nonatomic, strong, nullable) NSDictionary *replaceStrings;
@property (nonatomic, strong, nullable) NSDictionary *swipeGestures;
@property (nonatomic, strong, nullable) NSDictionary *listeners;
@property (nonatomic, assign) BOOL pullToRefresh;
@property (nonatomic, strong, nullable) NSArray *webviewPools;
@property (nonatomic, strong, nullable) id wvc;
@property (nonatomic, assign) BOOL userIdRegex;
@property (nonatomic, assign) BOOL contextMenuEnabled;
@property (nonatomic, strong, nullable) NSArray *contextMenuLinkActions;

// Methods
- (void)initializeRegexRules:(void * _Nullable * _Nullable)rules;
- (void)setNewRegexRules:(id _Nullable)rules regexRulesArray:(void * _Nullable * _Nullable)regexRulesArray;
- (nullable NSString *)getRegexRuleForURL:(NSString * _Nullable)urlString rules:(void * _Nullable)rules;
- (nullable NSString *)userAgentForUrl:(NSURL * _Nullable)url;

@end

NS_ASSUME_NONNULL_END

#endif /* GoNativeAppConfig_h */
