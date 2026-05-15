//
//  LEANIcons.h
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface LEANIcons : NSObject
@property (class, nonatomic, strong, readonly) LEANIcons *sharedIcons;
+ (nullable UIImage *)imageForIconIdentifier:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
@end
NS_ASSUME_NONNULL_END
