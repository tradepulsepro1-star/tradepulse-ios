// GoNativeAppConfig.m — Stub implementation replacing private GoNativeCore SPM package
#import "GoNativeAppConfig.h"

@implementation GoNativeAppConfig

+ (instancetype)sharedAppConfig {
    static GoNativeAppConfig *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GoNativeAppConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _useWKWebView = YES;
        _pullToRefresh = NO;
        _swipeGestures = YES;
        _enableWindowOpen = NO;
        _dynamicTypeEnabled = NO;
        _pinchToZoom = YES;
        _disableAnimations = NO;
        _iosShowOfflinePage = NO;
        _forceSessionCookieExpiry = 0;
        _showShareButton = NO;
        _showToolbar = NO;
        _iosAutoHideHomeIndicator = NO;
        _userAgentReady = YES;
        _injectMedianJS = NO;
        _disableEventRecorder = NO;
    }
    return self;
}

- (NSString *)userAgentForUrl:(NSURL *)url { return self.userAgent; }
- (void)initializeRegexRules:(NSArray<NSDictionary *> **)outRules { if (outRules) *outRules = @[]; }
- (void)setNewRegexRules:(NSDictionary *)rules regexRulesArray:(NSArray<NSDictionary *> **)outRules { if (outRules) *outRules = @[]; }
- (NSDictionary *)getRegexRuleForURL:(NSString *)urlString rules:(NSArray<NSDictionary *> *)rules { return nil; }

@end
