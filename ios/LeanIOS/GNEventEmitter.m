// GNEventEmitter.m — Stub implementation
#import "GNEventEmitter.h"
@implementation GNEventEmitter
+ (instancetype)shared { static GNEventEmitter *i = nil; static dispatch_once_t t; dispatch_once(&t, ^{ i = [GNEventEmitter new]; }); return i; }
- (void)emitEvent:(NSString *)eventName data:(NSDictionary *)data {}
@end
