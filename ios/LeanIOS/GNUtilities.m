// GNUtilities.m — Stub implementation
#import "GNUtilities.h"
@implementation GNUtilities
+ (BOOL)url:(NSString *)url1 matchesUrl:(NSString *)url2 {
    if (!url1 || !url2) return NO;
    return [url1 isEqualToString:url2];
}
@end
