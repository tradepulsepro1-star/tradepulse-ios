// GNBridge.m — Stub implementation
#import "GNBridge.h"

@implementation GNBridge
- (instancetype)init { self = [super init]; return self; }
- (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)options {}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options { return NO; }
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (nullable id<GNController>)getControllerForKey:(NSString *)key runner:(id)runner { return nil; }
@end
