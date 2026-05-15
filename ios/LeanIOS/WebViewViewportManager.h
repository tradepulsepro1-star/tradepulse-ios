//
//  WebViewViewportManager.h
//
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface WebViewViewportManager : NSObject
@property (class, nonatomic, strong, readonly) WebViewViewportManager *shared;
- (void)setViewportWithScale:(CGFloat)scale width:(nullable NSNumber *)width webView:(nullable WKWebView *)webView;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query webView:(nullable WKWebView *)webView completion:(void (^)(NSDictionary *))completion;
- (void)getViewportScale:(nullable WKWebView *)webView completion:(void (^)(NSDictionary *))completion;
- (void)updateViewport;
@end
NS_ASSUME_NONNULL_END
