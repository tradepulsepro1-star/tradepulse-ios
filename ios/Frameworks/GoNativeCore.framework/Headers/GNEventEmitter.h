#pragma once
#import <Foundation/Foundation.h>
@interface GNEventEmitter : NSObject
+ (instancetype)shared;
- (void)emitEvent:(NSString *)event data:(id)data;
@end
