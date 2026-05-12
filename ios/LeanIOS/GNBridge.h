// GNBridge.h — Stub header replacing private GoNativeCore SPM package

#ifndef GNBridge_h
#define GNBridge_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GNController;

NS_ASSUME_NONNULL_BEGIN

@interface GNBridge : NSObject

- (instancetype)init;
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary * _Nullable)options;
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options;
- (void)applicationDidBecomeActive:(UIApplication *)application;
- (void)applicationWillResignActive:(UIApplication *)application;
- (void)applicationDidEnterBackground:(UIApplication *)application;
- (void)applicationWillEnterForeground:(UIApplication *)application;
- (nullable id<GNController>)getControllerForKey:(NSString *)key runner:(id _Nullable)runner;

@end

NS_ASSUME_NONNULL_END

#endif /* GNBridge_h */
