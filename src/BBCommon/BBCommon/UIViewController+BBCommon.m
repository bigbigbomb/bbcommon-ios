//
//  Created by Brian Romanko on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIViewController+BBCommon.h"
#import "UIView+BBCommon.h"

static UIWindow *_overlayWindow = nil;

@implementation UIViewController(BBCommon)

- (UIViewController *)insertScreenshotOfControllerAsBackground:(UIViewController *)viewController {
    UIImageView *falseBackground = [[[UIImageView alloc] initWithImage:[viewController.view getScreenshot]] autorelease];
    [self.view insertSubview:falseBackground atIndex:0];
    BBResizeFrame(falseBackground, BBW(self.view), BBH(self.view));
    return self;
}

- (void)bbPresentViewController:(UIViewController *)viewControllerToPresent {
    [self.view endEditing:YES];

    //create an overlay window if it doesn't exist
    if (!_overlayWindow){
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        [_overlayWindow makeKeyAndVisible];
    }
    [_overlayWindow addSubview:viewControllerToPresent.view];
    [_overlayWindow bringSubviewToFront:viewControllerToPresent.view];
}

- (void)bbDismissViewController {
    [self.view removeFromSuperview];
    if ([[_overlayWindow subviews] count] == 0){
        [_overlayWindow release];
        _overlayWindow = nil;
        // find the frontmost window that is an actual UIWindow and make it keyVisible
        [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                [window makeKeyWindow];
                *stop = YES;
            }
        }];
    }
}

- (BOOL)hasDialogWithTag:(int)tag {
    for (UIView *view in [_overlayWindow subviews]) {
        if (view.tag == tag)
            return YES;
    }
    return NO;
}

@end