#pragma once
#import <UIKit/UIKit.h>
@interface UIImage (MedianIcons)
+ (UIImage *)imageWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
- (instancetype)initWithIconName:(NSString *)name size:(CGFloat)size color:(UIColor *)color;
@end
