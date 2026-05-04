// GNStubs.h - Auto-included stub declarations for GoNativeCore + MedianIcons
// Replaces the removed PCH dependency on GoNativeCore framework
#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef GoNativeAppConfig_DEFINED
#define GoNativeAppConfig_DEFINED

@interface GoNativeAppConfig : NSObject
+ (instancetype)sharedAppConfig;
+ (instancetype)shared;
@property (nonatomic) BOOL contextMenuEnabled;
@property (nonatomic, strong) NSArray *contextMenuLinkActions;
@property (nonatomic) NSUInteger maxWindows;
@property (nonatomic) BOOL pinchToZoom;
@property (nonatomic, strong) NSString *initialHost;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong) NSString *stringViewport;
@property (nonatomic, strong) NSString *sidebarMenuIcon;
@property (nonatomic, strong) NSNumber *forceViewportWidth;
@property (nonatomic, strong) NSNumber *interactiveDelay;
@property (nonatomic, strong) NSNumber *iosConnectionOfflineTime;
@property (nonatomic, strong) NSArray *navStructureLevels;
@property (nonatomic, strong) NSArray *navTitles;
@property (nonatomic, strong) NSArray *tabMenus;
@property (nonatomic, strong) NSArray *tabMenuRegexes;
@property (nonatomic, strong) NSArray *webviewPools;
@property (nonatomic, strong) NSArray *loginDetectRegexes;
@property (nonatomic, strong) NSDictionary *actions;
@property (nonatomic, strong) NSDictionary *customHeaders;
@property (nonatomic, strong) NSURL *loginDetectionURL;
@property (nonatomic, strong) UIImage *navigationTitleIcon;
@property (nonatomic, strong) UIImage *appIcon;
@property (nonatomic) NSUInteger forceSessionCookieExpiry;
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
