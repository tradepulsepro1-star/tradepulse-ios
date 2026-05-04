// GonativeIO-Swift.h - Stub to replace Median Swift-generated header
// All methods are no-ops so TradePulse compiles without the Median SDK

#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

// GNController protocol - used for splash screen and loading spinner controllers
@protocol GNController <NSObject>
@optional
- (void)show;
- (void)hide;
- (void)hideAfterDelay:(double)delay;
- (void)triggerEvent:(NSString *)event;
- (void)triggerEvent:(NSString *)event data:(id)data;
@end

// GNBridge - the main Median bridge class referenced everywhere
@interface GNBridge : NSObject

// App lifecycle
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)applicationWillTerminate:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary *)options;
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

// WebView runner methods
- (void)runnerDidLoad:(id)runner;
- (void)runnerWillAppear:(id)runner;
- (void)runnerWillDisappear:(id)runner;
- (void)runner:(id)runner willTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator;
- (BOOL)runner:(id)runner shouldLoadRequestWithURL:(NSURL *)url withData:(NSDictionary *)data;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation withRunner:(id)runner;
- (void)webView:(WKWebView *)webView handleURL:(NSURL *)url;
- (BOOL)webView:(WKWebView *)webView shouldDownloadUrl:(NSURL *)url;
- (void)switchToWebView:(WKWebView *)webView withRunner:(id)runner;
- (void)hideWebViewWithRunner:(id)runner;

// Script loading
- (void)loadUserScriptsForContentController:(WKUserContentController *)contentController;
- (NSArray *)getInitialUrlQueryItems;

// Controller factory
- (id<GNController>)getControllerForKey:(NSString *)key runner:(id)runner;

@end
