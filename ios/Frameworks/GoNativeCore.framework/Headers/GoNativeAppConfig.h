#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
@property (nonatomic, strong) NSString *customUserAgent;
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
