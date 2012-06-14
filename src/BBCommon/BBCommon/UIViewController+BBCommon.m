//
//  Created by Brian Romanko on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIViewController+BBCommon.h"
#import "UIView+BBCommon.h"

UIWindow *_overlayWindow;

@implementation UIViewController(BBCommon)

- (UIViewController *)insertScreenshotOfControllerAsBackground:(UIViewController *)viewController {
    UIImageView *falseBackground = [[[UIImageView alloc] initWithImage:[viewController.view getScreenshot]] autorelease];
    [self.view insertSubview:falseBackground atIndex:0];
    BBResizeFrame(falseBackground, BBW(self.view), BBH(self.view));
    return self;
}

- (void)bbPresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    //create an overlay window if it doesn't exist
    if (!_overlayWindow){
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.userInteractionEnabled = YES;
        _overlayWindow.backgroundColor = [UIColor clearColor];
    }
    viewControllerToPresent.view.alpha = 0;
    [_overlayWindow addSubview:viewControllerToPresent.view];
    [_overlayWindow bringSubviewToFront:viewControllerToPresent.view];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         viewControllerToPresent.view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                        if(finished)
                            completion();
                     }];
    [UIView setAnimationsEnabled:YES];
}

+ (void)bbDismissViewController:(BOOL)animated completion:(void(^)(void))completion {
    UIView *v = [[_overlayWindow subviews] objectAtIndex:0];
    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:0.3
                          delay:0
                        options:0
                     animations:^{
                         v.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [v removeFromSuperview];
                        if(finished)
                            completion();
                     }];
    [UIView setAnimationsEnabled:YES];
    if ([[_overlayWindow subviews] count] == 0){
        [_overlayWindow release];
    }
}

@end