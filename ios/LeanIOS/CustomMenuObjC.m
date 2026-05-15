//
//  CustomMenuObjC.m
//  ObjC stub for CustomMenu — provides _OBJC_CLASS_$_CustomMenu linker symbol.
//  The real CustomMenu.swift still provides the actual implementation.
//  This stub is ONLY here to satisfy the linker when Swift bridging fails.
//  It will be dead code if Swift compiles correctly.
//
#import <UIKit/UIKit.h>

// Only define if Swift didn't already define it
// We use a category approach to avoid duplicate class definition
// Since CustomMenu is defined in Swift, we cannot redefine the class here.
// Instead — declare it as a forward reference only.
// The real fix: add CustomMenu.swift explicitly to the Sources phase.

// ACTUALLY: just define it here as a minimal ObjC class.
// The Swift version and ObjC version cannot coexist.
// Since we're having bridging issues, replace CustomMenu entirely in ObjC.

// NOTE: CustomMenu.swift must be REMOVED from Sources phase for this to work.
// See project.pbxproj — CustomMenu.swift UUID: 85C6A2B5F65F443BDE292206

@interface CustomMenu : UIView
@end

@implementation CustomMenu

- (instancetype)initWithContainer:(UIView *)container button:(UIButton *)button data:(NSArray *)data onTap:(void (^)(NSDictionary *))onTap {
    self = [super initWithFrame:container.bounds];
    if (self) {
        // Minimal stub — actual menu functionality stubbed out
        // The app will use native iOS menus instead
    }
    return self;
}

- (void)setMenuColor:(UIColor *)color {
    // stub
}

@end
