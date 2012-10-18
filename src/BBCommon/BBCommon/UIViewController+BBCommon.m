//
//  Created by Brian Romanko on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+BBCommon.h"
#import "UIView+BBCommon.h"

#pragma mark -

static UIWindow *_overlayWindow = nil;
static char kBBViewControllerDelegateObjectKey;

@implementation UIViewController(BBCommon)

@dynamic bbViewControllerDelegate;

- (id<BBViewControllerDelegate>)bbViewControllerDelegate {
    return (id<BBViewControllerDelegate>)objc_getAssociatedObject(self, &kBBViewControllerDelegateObjectKey);
}

- (void)setBbViewControllerDelegate:(id <BBViewControllerDelegate>)bbViewControllerDelegate {
    objc_setAssociatedObject(self, &kBBViewControllerDelegateObjectKey, bbViewControllerDelegate, OBJC_ASSOCIATION_ASSIGN);
}


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
    }
    [_overlayWindow makeKeyAndVisible];

    if ([viewControllerToPresent.bbViewControllerDelegate respondsToSelector:@selector(viewControllerWillBePresented:)])
        [viewControllerToPresent.bbViewControllerDelegate viewControllerWillBePresented:viewControllerToPresent];

    [_overlayWindow addSubview:viewControllerToPresent.view];
    [_overlayWindow bringSubviewToFront:viewControllerToPresent.view];

    if ([viewControllerToPresent.bbViewControllerDelegate respondsToSelector:@selector(viewControllerDidGetPresented:)])
        [viewControllerToPresent.bbViewControllerDelegate viewControllerDidGetPresented:viewControllerToPresent];
}

- (void)bbDismissViewController {
    if ([self.bbViewControllerDelegate respondsToSelector:@selector(viewControllerWillBeDismissed:)])
        [self.bbViewControllerDelegate viewControllerWillBeDismissed:self];

    [self.view removeFromSuperview];

    if ([self.bbViewControllerDelegate respondsToSelector:@selector(viewControllerDidGetDismissed:)])
        [self.bbViewControllerDelegate viewControllerDidGetDismissed:self];

    if ([[_overlayWindow subviews] count] == 0) {
        // find the frontmost window that is an actual UIWindow and make it keyVisible
        [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
            if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal && window != _overlayWindow) {
                [window makeKeyAndVisible];
                *stop = YES;
            }
        }];
    }
}

@end