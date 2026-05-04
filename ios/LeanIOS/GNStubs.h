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

// All properties used across LeanIOS source files
@property (nonatomic) BOOL contextMenuEnabled;
@property (nonatomic, strong) NSArray *contextMenuLinkActions;
@property (nonatomic) NSUInteger maxWindows;
@property (nonatomic) BOOL pinchToZoom;
@property (nonatomic) BOOL pullToRefresh;
@property (nonatomic) BOOL swipeGestures;
@property (nonatomic) BOOL dynamicTypeEnabled;
@property (nonatomic) BOOL disableAnimations;
@property (nonatomic) BOOL disableEventRecorder;
@property (nonatomic) BOOL enableWindowOpen;
@property (nonatomic) BOOL injectMedianJS;
@property (nonatomic) BOOL useWKWebView;
@property (nonatomic) BOOL userAgentReady;
@property (nonatomic) BOOL showShareButton;
@property (nonatomic) BOOL showToolbar;
@property (nonatomic) BOOL iosAutoHideHomeIndicator;
@property (nonatomic) BOOL iosShowOfflinePage;
@property (nonatomic, strong) NSString *initialHost;
@property (nonatomic, strong) NSURL *initialURL;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *stringViewport;
@property (nonatomic, strong) NSString *sidebarMenuIcon;
@property (nonatomic, strong) NSString *sidebarIcon;
@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *userAgent;
@property (nonatomic, strong) NSString *userIdRegex;
@property (nonatomic, strong) NSString *currentMenuID;
@property (nonatomic, strong) NSString *signupURL;
@property (nonatomic, strong) NSString *targetFrame;
@property (nonatomic, strong) NSString *iosTheme;
@property (nonatomic, strong) NSString *iosSidebarFont;
@property (nonatomic, strong) NSNumber *forceViewportWidth;
@property (nonatomic, strong) NSNumber *interactiveDelay;
@property (nonatomic, strong) NSNumber *iosConnectionOfflineTime;
@property (nonatomic, strong) NSNumber *forceSessionCookieExpiry;
@property (nonatomic, strong) NSArray *navStructureLevels;
@property (nonatomic, strong) NSArray *navTitles;
@property (nonatomic, strong) NSArray *tabMenus;
@property (nonatomic, strong) NSArray *tabMenuIDs;
@property (nonatomic, strong) NSArray *tabMenuRegexes;
@property (nonatomic, strong) NSArray *webviewPools;
@property (nonatomic, strong) NSArray *loginDetectRegexes;
@property (nonatomic, strong) NSArray *loginDetectLocations;
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *menus;
@property (nonatomic, strong) NSArray *listeners;
@property (nonatomic, strong) NSArray *toolbarItems;
@property (nonatomic, strong) NSArray *segmentedControlItems;
@property (nonatomic, strong) NSArray *replaceStrings;
@property (nonatomic, strong) NSDictionary *actions;
@property (nonatomic, strong) NSDictionary *customHeaders;
@property (nonatomic, strong) NSDictionary *font;
@property (nonatomic, strong) NSURL *loginDetectionURL;
@property (nonatomic, strong) UIImage *navigationTitleIcon;
@property (nonatomic, strong) UIImage *appIcon;
- (NSString *)userAgentForUrl:(NSURL *)url;
- (NSDictionary *)getRegexRuleForURL:(NSString *)url rules:(id)rules;
- (void)initializeRegexRules:(id *)rules;
- (void)setNewRegexRules:(id)rules regexRulesArray:(id *)array;
@end

@interface GNBridge : NSObject
@end

@interface GNJSBridgeHandler : NSObject
+ (instancetype)shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc;
@end

@interface GNEventEmitter : NSObject
+ (instancetype)shared;
- (void)emitEvent:(NSString *)event data:(id)data;
@end

extern NSString * const kGoNativeAppConfigNotificationUserAgentReady;
extern NSString * const kGoNativeCoreDeviceDidShake;

@interface UIImage (MedianIcons)
+ (UIImage *)imageWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
- (instancetype)initWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
@end

#endif
#endif // __OBJC__
