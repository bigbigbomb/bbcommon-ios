//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UINavigationController+BBCommon.h"
#import "BBTransitioningViewControllerProtocol.h"

@implementation UINavigationController (BBCommon)

- (SEL)fromSelectorForNavigationType:(BBNavigationType)type {
    if (type == BBNavigationTypePush) {
        return @selector(pushTransitionOutToViewController:finish:);
    } else {
        return @selector(popTransitionOutToViewController:finish:);
    }
}

- (SEL)toSelectorForNavigationType:(BBNavigationType)type {
    if (type == BBNavigationTypePush) {
        return @selector(pushTransitionInFromViewController:);
    } else {
        return @selector(popTransitionInFromViewController:);
    }
}

- (BOOL)useDefaultTransitionFrom:(UIViewController *)fromViewController to:(UIViewController *)toViewController navigationType:(BBNavigationType)navigationType animated:(BOOL)animated {
    if ([fromViewController respondsToSelector:[self fromSelectorForNavigationType:navigationType]] ||
        [toViewController respondsToSelector:[self toSelectorForNavigationType:navigationType]])
        return NO;
    else
        return animated;
}

- (BOOL)trySelector:(SEL)selector on:(id)targetObject withObject:(id)param1 withObject:(id)param2 {
    if ([targetObject respondsToSelector:selector]) {
        [targetObject performSelector:selector withObject:param1 withObject:param2];
        return YES;
    }
    return NO;
}

- (void)transitionTo:(UIViewController *)toViewController from:(UIViewController *)fromViewController action:(BBNavigationType)navigationType {
    [self trySelector:[self toSelectorForNavigationType:navigationType] on:toViewController withObject:fromViewController withObject:nil];
}

- (void)transitionFrom:(UIViewController *)fromViewController to:(UIViewController *)toViewController action:(BBNavigationType)navigationType finish:(void (^)())finishBlock {
    if (![self trySelector:[self fromSelectorForNavigationType:navigationType] on:toViewController withObject:fromViewController withObject:finishBlock])
        finishBlock();
}

- (void)bbPushViewController:(UIViewController *)toViewController animated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;

    if (fromViewController == toViewController) return;

    if ([self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePush animated:animated]) {
        [self pushViewController:toViewController animated:animated];
    } else {
        void(^finishBlock)()  = ^{
            [self pushViewController:toViewController animated:NO];
            [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePush];
        };

        [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePush finish:finishBlock];
    }
}

- (void)bbPopViewControllerAnimated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;
    NSInteger inViewIndex = [self.viewControllers indexOfObject:fromViewController] - 1;

    if (inViewIndex < 0) return; // Do nothing if at root view controller

    UIViewController *toViewController = inViewIndex > -1 ? [self.viewControllers objectAtIndex:(NSUInteger) inViewIndex] : nil;

    void(^finishBlock)()  = ^{
        [self popViewControllerAnimated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop finish:finishBlock];
}

- (void)bbPopToViewController:(UIViewController *)toViewController animated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;

    void(^finishBlock)()  = ^{
        [self popToViewController:toViewController animated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop finish:finishBlock];
}

- (void)bbPopToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;
    UIViewController *toViewController = [self.viewControllers objectAtIndex:0];

    if (fromViewController == toViewController) return; // Do nothing if already at root view controller

    void(^finishBlock)()  = ^{
        [self popToRootViewControllerAnimated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop finish:finishBlock];}

@end