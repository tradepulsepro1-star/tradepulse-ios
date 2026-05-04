#pragma once
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GNJSBridgeHandler : NSObject
+ (instancetype)shared;
- (void)handleUrl:(NSURL *)url query:(NSDictionary *)query wvc:(id)wvc;
@end
