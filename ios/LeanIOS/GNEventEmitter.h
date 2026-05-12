// GNEventEmitter.h — Stub header replacing private GoNativeCore SPM package

#ifndef GNEventEmitter_h
#define GNEventEmitter_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GNEventEmitter : NSObject

+ (instancetype)shared;
- (void)emitEvent:(NSString *)eventName data:(nullable NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END

#endif /* GNEventEmitter_h */
