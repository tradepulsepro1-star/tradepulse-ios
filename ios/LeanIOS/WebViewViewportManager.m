//
//  WebViewViewportManager.m — ObjC replacement for WebViewViewportManager.swift
//
#import "WebViewViewportManager.h"

@implementation WebViewViewportManager

+ (instancetype)shared {
    static WebViewViewportManager *s; static dispatch_once_t t;
    dispatch_once(&t, ^{ s = [self new]; });
    return s;
}

- (void)setViewportWithScale:(CGFloat)scale width:(NSNumber *)width webView:(WKWebView *)webView {
    NSString *js = nil;
    if (scale > 0) {
        NSString *s = [NSString stringWithFormat:@"%.3f", scale];
        double zoom = scale;
        js = [NSString stringWithFormat:
            @"(function(){"
            "var m=document.querySelector('meta[name=viewport]');"
            "if(!m){m=document.createElement('meta');m.name='viewport';document.head.appendChild(m);}"
            "var w=window.screen.width/%f;"
            "m.setAttribute('content','width='+w+',initial-scale=%@,user-scalable=no');"
            "})()", zoom, s];
    } else if (width) {
        js = [NSString stringWithFormat:
            @"(function(){"
            "var m=document.querySelector('meta[name=viewport]');"
            "if(!m){m=document.createElement('meta');m.name='viewport';document.head.appendChild(m);}"
            "m.setAttribute('content','width=%@,user-scalable=no');"
            "})()", width];
    }
    if (js && webView) {
        [webView evaluateJavaScript:js completionHandler:nil];
    }
}

- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query webView:(WKWebView *)webView completion:(void (^)(NSDictionary *))completion {
    if (completion) completion(@{});
}

- (void)getViewportScale:(WKWebView *)webView completion:(void (^)(NSDictionary *))completion {
    if (completion) completion(@{@"zoom": @1});
}

- (void)updateViewport {}

@end
