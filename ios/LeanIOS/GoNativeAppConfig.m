// GoNativeAppConfig.m — Complete stub replacing private GoNativeCore SPM package
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

+ (instancetype)shared {
    return [GoNativeAppConfig sharedAppConfig];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // WebView
        _useWKWebView = YES;
        _pullToRefresh = NO;
        _swipeGestures = YES;
        _enableWindowOpen = NO;
        _dynamicTypeEnabled = NO;
        _pinchToZoom = YES;
        _disableAnimations = NO;
        _injectMedianJS = NO;
        _disableEventRecorder = NO;
        _disableDocumentOpenWith = NO;
        _enableWebConsoleLogs = NO;
        _keepScreenOn = NO;
        _useWebpageTitle = NO;
        _windowOpenHideNavbar = NO;
        _iosShowOfflinePage = NO;
        _forceSessionCookieExpiry = 0;
        _userAgentReady = YES;
        // UI
        _iosAutoHideHomeIndicator = NO;
        _iosEnableOverlayInStatusBar = NO;
        _iosEnableBlurInStatusBar = NO;
        _iosFullScreenWebview = NO;
        _transparentNavBar = NO;
        _isNavigationTitleImage = NO;
        // Navigation
        _showShareButton = NO;
        _showToolbar = NO;
        _showNavigationBar = YES;
        _showNavigationMenu = NO;
        _showKeyboardAccessoryView = NO;
        _hideNavBarOnScroll = NO;
        _hideTabBarOnScroll = NO;
        _toolbarEnabled = NO;
        // Windows
        _maxWindows = 10;
        _maxWindowsAutoClose = NO;
        // Context menu
        _contextMenuEnabled = NO;
        _contextMenuLinkActions = @[];
        // Auth
        _facebookEnabled = NO;
        _iOSRequestATTConsentOnLoad = NO;
        // Custom scripts
        _hasCustomCSS = NO;
        _hasCustomJS = NO;
        _hasIosCustomCSS = NO;
        _hasIosCustomJS = NO;
    }
    return self;
}

- (NSString *)userAgentForUrl:(NSURL *)url { return self.userAgent; }
- (void)initializeRegexRules:(NSArray<NSDictionary *> **)outRules { if (outRules) *outRules = @[]; }
- (void)setNewRegexRules:(NSDictionary *)rules regexRulesArray:(NSArray<NSDictionary *> **)outRules { if (outRules) *outRules = @[]; }
- (NSDictionary *)getRegexRuleForURL:(NSString *)urlString rules:(NSArray<NSDictionary *> *)rules { return nil; }
- (BOOL)shouldShowSidebarForUrl:(NSString *)url { return NO; }

@end
