//
//  LEANLaunchScreenManager.m
//  Median
//
//  Created by bld on 8/11/23.
//  Copyright © 2023 Median. All rights reserved.
//

#import "LEANLaunchScreenManager.h"
#import "LEANAppDelegate.h"
// GonativeIO-Swift.h removed — all Swift types use GNStubs.h ObjC declarations
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
    // NOTE: no separate centered "LaunchCenter" box — full-bleed background image only.
    // The JS-injected splash (with its own gold progress bar) takes over from here.
    
    self.launchScreen = [[UIImageView alloc] init];
    self.launchScreen.image = [UIImage imageNamed:@"LaunchBackground"];
    self.launchScreen.contentMode = UIViewContentModeScaleAspectFill;
    self.launchScreen.clipsToBounds = YES;
    self.launchScreen.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIWindow *currentWindow = GNKeyWindow();
    if (!currentWindow) {
        // No window available yet — skip launch screen overlay
        self.isShown = NO;
        return;
    }
    [currentWindow addSubview:self.launchScreen];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.launchScreen.topAnchor constraintEqualToAnchor:currentWindow.topAnchor],
        [self.launchScreen.bottomAnchor constraintEqualToAnchor:currentWindow.bottomAnchor],
        [self.launchScreen.leadingAnchor constraintEqualToAnchor:currentWindow.leadingAnchor],
        [self.launchScreen.trailingAnchor constraintEqualToAnchor:currentWindow.trailingAnchor]
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
