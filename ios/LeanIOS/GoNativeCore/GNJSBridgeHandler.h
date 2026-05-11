// GNJSBridgeHandler.h — Stub header replacing private GoNativeCore SPM package

#ifndef GNJSBridgeHandler_h
#define GNJSBridgeHandler_h

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GNJSBridgeHandler : NSObject

+ (instancetype)shared;
- (void)handleUrl:(nullable NSURL *)url query:(nullable NSDictionary *)query wvc:(nullable id)wvc;

@end

NS_ASSUME_NONNULL_END

#endif /* GNJSBridgeHandler_h */
