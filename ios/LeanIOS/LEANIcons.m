//
//  LEANIcons.m — ObjC replacement for LEANIcons.swift
//  Pure ObjC — no Swift bridging needed
//
#import "LEANIcons.h"

@implementation LEANIcons

+ (instancetype)sharedIcons {
    static LEANIcons *s; static dispatch_once_t t;
    dispatch_once(&t, ^{ s = [self new]; });
    return s;
}

+ (UIImage *)imageForIconIdentifier:(NSString *)name size:(CGFloat)size color:(UIColor *)color {
    UIImageSymbolConfiguration *config = [UIImageSymbolConfiguration configurationWithPointSize:size];
    UIImage *img = [UIImage systemImageNamed:name withConfiguration:config];
    if (!img) {
        img = [UIImage systemImageNamed:@"circle" withConfiguration:config];
    }
    return [img imageWithTintColor:color renderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
