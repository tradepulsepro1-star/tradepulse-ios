//
//  LEANToolbarManager.h
//  GoNativeIOS
//
//  Created by Weiyin He on 5/20/15.
//  Copyright (c) 2015 GoNative.io LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LEANWebViewController.h"

typedef NS_ENUM(NSInteger, LEANToolbarVisibilityByPages) {
    LEANToolbarVisibilityByPagesAll = 0,
    LEANToolbarVisibilityByPagesSpecific = 1
};

typedef NS_ENUM(NSInteger, LEANToolbarVisibilityByBackButton) {
    LEANToolbarVisibilityByBackButtonAlways = 0,
    LEANToolbarVisibilityByBackButtonActive = 1
};



@interface LEANToolbarManager : NSObject
- (instancetype)initWithToolbar:(UIToolbar*)toolbar heightConstraint:(NSLayoutConstraint *)heightConstraint wvc:(LEANWebViewController*)wvc;
- (void)handleUrl:(NSURL *)url query:(NSDictionary*)query;
- (void)didLoadUrl:(NSURL*)url;
- (void)setToolbarEnabled:(BOOL)enabled;
@property NSString *urlMimeType;
@end
