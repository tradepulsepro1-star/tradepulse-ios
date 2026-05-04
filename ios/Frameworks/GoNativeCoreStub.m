// GoNativeCoreStub.m - Stub implementations so linker does not fail
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GoNativeAppConfig : NSObject
+ (instancetype)sharedAppConfig;
+ (instancetype)shared;
@end
@implementation GoNativeAppConfig
+ (instancetype)sharedAppConfig {
    static GoNativeAppConfig *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GoNativeAppConfig alloc] init]; }); return i;
}
+ (instancetype)shared { return [self sharedAppConfig]; }
- (BOOL)contextMenuEnabled { return NO; }
- (NSArray *)contextMenuLinkActions { return @[]; }
- (NSUInteger)maxWindows { return 20; }
- (BOOL)pinchToZoom { return YES; }
- (NSString *)initialHost { return @""; }
- (NSString *)publicKey { return @""; }
- (NSString *)stringViewport { return @""; }
- (NSString *)sidebarMenuIcon { return @"fas fa-bars"; }
- (NSNumber *)forceViewportWidth { return nil; }
- (NSNumber *)interactiveDelay { return @0; }
- (NSNumber *)iosConnectionOfflineTime { return @10; }
- (NSArray *)navStructureLevels { return @[]; }
- (NSArray *)navTitles { return @[]; }
- (NSArray *)tabMenus { return @[]; }
- (NSArray *)tabMenuRegexes { return @[]; }
- (NSArray *)webviewPools { return @[]; }
- (NSArray *)loginDetectRegexes { return @[]; }
- (NSDictionary *)actions { return @{}; }
- (NSDictionary *)customHeaders { return @{}; }
- (NSURL *)loginDetectionURL { return nil; }
- (UIImage *)navigationTitleIcon { return nil; }
- (UIImage *)appIcon { return nil; }
- (NSUInteger)forceSessionCookieExpiry { return 0; }
- (NSString *)userAgentForUrl:(NSURL *)url { return @""; }
- (NSDictionary *)getRegexRuleForURL:(NSString *)url rules:(id)rules { return nil; }
- (void)initializeRegexRules:(id *)rules {}
- (void)setNewRegexRules:(id)rules regexRulesArray:(id *)array {}
@end

@interface GNBridge : NSObject
@end
@implementation GNBridge
@end

@interface GNJSBridgeHandler : NSObject
+ (instancetype)shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc;
@end
@implementation GNJSBridgeHandler
+ (instancetype)shared {
    static GNJSBridgeHandler *i; static dispatch_once_t t;
    dispatch_once(&t, ^{ i = [[GNJSBridgeHandler alloc] init]; }); return i;
}
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc {}
@end

@interface GNEventEmitter : NSObject
+ (instancetype)shared;
- (void)emitEvent:(NSString *)event data:(id)data;
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
