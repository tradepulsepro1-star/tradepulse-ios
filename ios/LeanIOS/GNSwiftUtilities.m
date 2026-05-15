//
//  GNSwiftUtilities.m — ObjC replacement for GNSwiftUtilities.swift
//
#import "GNSwiftUtilities.h"

@implementation GNSwiftUtilities

+ (NSString *)deviceTokenWithData:(NSData *)data {
    NSMutableString *token = [NSMutableString stringWithCapacity:data.length * 2];
    const unsigned char *bytes = data.bytes;
    for (NSUInteger i = 0; i < data.length; i++) {
        [token appendFormat:@"%02x", bytes[i]];
    }
    return [token copy];
}

@end
