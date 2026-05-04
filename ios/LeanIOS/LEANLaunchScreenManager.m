//
//  LEANLaunchScreenManager.m
//  Median
//
//  Created by bld on 8/11/23.
//  Copyright © 2023 Median. All rights reserved.
//

#import "LEANLaunchScreenManager.h"
#import "LEANAppDelegate.h"
#import "GonativeIO-Swift.h"
#import "GNStubs.h"

@interface LEANLaunchScreenManager()
// GNController removed (GoNative SDK)
@property UIImageView *launchScreen;
@property BOOL isShown;
@end

@implementation LEANLaunchScreenManager

+ (LEANLaunchScreenManager *)sharedManager {
    static LEANLaunchScreenManager *shared;
    @synchronized(self) {
        if (!shared) {
            shared = [[LEANLaunchScreenManager alloc] init];
        }
        return shared;
    }
}

- (void)showWithParentViewController:(UIViewController *)vc {
    if (self.isShown) {
        return;
    }
    
    self.isShown = YES;
    
    // GNBridge splashScreen controller removed — using native UIImageView fallback
    
    self.launchScreen = [[UIImageView alloc] init];
    self.launchScreen.image = [UIImage imageNamed:@"LaunchBackground"];
    self.launchScreen.clipsToBounds = YES;
    self.launchScreen.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIImageView *centerImageView = [[UIImageView alloc] init];
    centerImageView.image = [UIImage imageNamed:@"LaunchCenter"];
    centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    centerImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.launchScreen addSubview:centerImageView];
    UIWindow *currentWindow = GNKeyWindow();
    [currentWindow addSubview:self.launchScreen];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.launchScreen.topAnchor constraintEqualToAnchor:currentWindow.topAnchor],
        [self.launchScreen.bottomAnchor constraintEqualToAnchor:currentWindow.bottomAnchor],
        [self.launchScreen.leadingAnchor constraintEqualToAnchor:currentWindow.leadingAnchor],
        [self.launchScreen.trailingAnchor constraintEqualToAnchor:currentWindow.trailingAnchor]
    ]];
    
    [NSLayoutConstraint activateConstraints:@[
        [centerImageView.widthAnchor constraintEqualToConstant:200],
        [centerImageView.heightAnchor constraintEqualToConstant:400],
        [centerImageView.centerXAnchor constraintEqualToAnchor:self.launchScreen.centerXAnchor],
        [centerImageView.centerYAnchor constraintEqualToAnchor:self.launchScreen.centerYAnchor]
    ]];
}

- (void)hide {
    
    if (self.launchScreen) {
        [self.launchScreen removeFromSuperview];
        self.launchScreen = nil;
    }
}

- (void)hideAfterDelay:(double)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
}

@end
