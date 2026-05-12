//
//  GoNativeAppConfig.m — Stub replacing private GoNativeCore SPM package
//

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
        _appName = @"TradePulse";
        _useWKWebView = YES;
        _allowsBackForwardNavigationGestures = YES;
        _injectMedianJS = NO;
        _disableAnimations = NO;
        _disableEventRecorder = NO;
        _userAgentReady = YES;
        _pullToRefresh = NO;
        _enableWindowOpen = NO;
        _dynamicTypeEnabled = NO;
        _pinchToZoom = NO;
        _iosAutoHideHomeIndicator = NO;
        _iosShowOfflinePage = NO;
        _showToolbar = NO;
        _showShareButton = NO;
        _maxWindows = 1;
        _interactiveDelay = 0.0;
        _forceSessionCookieExpiry = 0.0;
        _iosConnectionOfflineTime = 10.0;
        _forceViewportWidth = 0.0;
        _contextMenuEnabled = NO;
        _contextMenuLinkActions = @[];
        _customHeaders = @{};
        _listeners = @{};
    }
    return self;
}

- (void)initializeRegexRules:(void **)rules {
    if (rules) *rules = nil;
}

- (void)setNewRegexRules:(id)rules regexRulesArray:(void **)regexRulesArray {
    if (regexRulesArray) *regexRulesArray = nil;
}

- (NSString *)getRegexRuleForURL:(NSString *)urlString rules:(void *)rules {
    return nil;
}

- (NSString *)userAgentForUrl:(NSURL *)url {
    return nil;
}

@end
