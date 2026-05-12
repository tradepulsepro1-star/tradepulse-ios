// GonativeIO-Swift.h — Stub for private GoNativeCore/Median Swift types
// NOTE: Swift @objc classes (WebViewViewportManager, WindowsController, ContextMenuHandler)
// are declared by Xcode at build time from Swift source files — do NOT redeclare them here.
// This stub only provides types that came from the private Median SPM package.

#ifndef GonativeIO_Swift_h
#define GonativeIO_Swift_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// GNController protocol — from private Median SPM package (go-native-core)
/// Used by LEANLaunchScreenManager, LEANLoadingSpinnerManager
@protocol GNController <NSObject>
@optional
- (void)triggerEvent:(NSString *)eventName;
@end

NS_ASSUME_NONNULL_END

#endif /* GonativeIO_Swift_h */
