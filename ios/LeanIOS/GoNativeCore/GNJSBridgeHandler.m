// GNJSBridgeHandler.m — Stub implementation
#import "GNJSBridgeHandler.h"
@implementation GNJSBridgeHandler
+ (instancetype)shared { static GNJSBridgeHandler *i = nil; static dispatch_once_t t; dispatch_once(&t, ^{ i = [GNJSBridgeHandler new]; }); return i; }
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc {}
@end
