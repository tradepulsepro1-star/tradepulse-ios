//
//  LEANRegexRulesManager.m
//  GonativeIO
//
//  Created by bld ai on 6/14/22.
//  Copyright © 2022 GoNative.io LLC. All rights reserved.
//

#import "LEANRegexRulesManager.h"
#import "LEANWindowsManager.h"
#import "GonativeIO-Stubs.h"

@interface LEANRegexRulesManager()
@property LEANWindowsManager *windowsManager;
@property NSArray<NSDictionary *> *regexRules;
@end

@implementation LEANRegexRulesManager

- (instancetype)initWithWvc:(LEANWebViewController *)wvc
{
    self = [super init];
    if (self) {
        self.windowsManager = [[LEANWindowsManager alloc] initWithWvc:wvc];
        [self initializeValues];
    }
    return self;
}

- (void)initializeValues {
    NSArray<NSDictionary *> *regexRules;
    [[GoNativeAppConfig sharedAppConfig] initializeRegexRules:&regexRules];
    self.regexRules = regexRules;
}

- (void)handleUrl:(NSURL *)url query:(NSDictionary*)query {
    if ([@"/set" isEqualToString:url.path]) {
        [self setRules:query[@"rules"]];
    }
}

- (void)setRules:(NSArray *)rules {
    NSArray *regexRules;
    [[GoNativeAppConfig sharedAppConfig] setNewRegexRules:rules regexRulesArray:&regexRules];
    self.regexRules = regexRules;
}

- (BOOL)shouldHandleRequest:(NSURLRequest *)request {
    NSURL *url = [request URL];
    NSString *urlString = [url absoluteString];
    NSString* hostname = [url host];
    
    // ALWAYS handle OAuth/auth domains internally — never open in SFSafariViewController
    // This ensures ASWebAuthenticationSession intercept in LEANWebViewController can handle them
    if (hostname) {
        if ([hostname isEqualToString:@"accounts.google.com"] ||
            [hostname hasSuffix:@".google.com"] ||
            [hostname isEqualToString:@"app.base44.com"] ||
            [hostname hasSuffix:@".base44.com"]) {
            return YES;
        }
    }
    
    NSDictionary *matchResult = [[GoNativeAppConfig sharedAppConfig] getRegexRuleForURL:urlString rules:self.regexRules];
    
    BOOL matchedRegex = [matchResult[@"matches"] boolValue];
    if (matchedRegex) {
        NSString *mode = matchResult[@"mode"];
        
        if ([mode isKindOfClass:[NSString class]] && ![mode isEqualToString:@"internal"]) {
            [self.windowsManager openUrl:request.URL mode:mode];
            return NO;
        }
    } else  {
        NSString *initialHost = [GoNativeAppConfig sharedAppConfig].initialHost;
        
        if (initialHost && hostname && ![hostname isEqualToString:initialHost] && ![hostname hasSuffix:[@"." stringByAppendingString:initialHost]]) {
            [self.windowsManager openUrl:request.URL mode:@"external"];
            return NO;
        }
    }
    
    return YES;
}

@end
