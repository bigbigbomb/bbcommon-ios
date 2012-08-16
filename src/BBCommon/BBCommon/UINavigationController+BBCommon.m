//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UINavigationController+BBCommon.h"
#import "BBTransitioningViewControllerProtocol.h"


#define DISABLE_CUSTOM_TRANSITIONS 0
#define LOG_NAVIGATION_STACK       0

@implementation UINavigationController (BBCommon)

#if LOG_NAVIGATION_STACK
- (void)logNavigationStack {
    NSLog(@"Navigation Stack Log");
    NSUInteger count = [self.viewControllers count];
    for (NSInteger i = count-1; i >= 0; i--) {
        NSLog(@"%d) %@", i, [self.viewControllers objectAtIndex:(NSUInteger) i]);
    }
}
#endif

- (SEL)fromSelectorForNavigationType:(BBNavigationType)type {
    if (type == BBNavigationTypePush) {
        return @selector(pushTransitionOutToViewController:completion:);
    } else {
        return @selector(popTransitionOutToViewController:completion:);
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
        return !animated;
    else
        return YES;
}

- (BOOL)trySelector:(SEL)selector on:(id)targetObject withObject:(id)param1 {
    if ([targetObject respondsToSelector:selector]) {
        [targetObject performSelector:selector withObject:param1];
        return YES;
    }
    return NO;
}

- (BOOL)trySelector:(SEL)selector on:(id)targetObject withObject:(id)param1 withObject:(id)param2 {
    if ([targetObject respondsToSelector:selector]) {
        [targetObject performSelector:selector withObject:param1 withObject:param2];
        return YES;
    }
    return NO;
}

- (void)transitionTo:(UIViewController *)toViewController from:(UIViewController *)fromViewController action:(BBNavigationType)navigationType {
    [self trySelector:[self toSelectorForNavigationType:navigationType] on:toViewController withObject:fromViewController];
}

- (void)transitionFrom:(UIViewController *)fromViewController to:(UIViewController *)toViewController action:(BBNavigationType)navigationType completion:(void (^)(BOOL completed))completion {
    if (![self trySelector:[self fromSelectorForNavigationType:navigationType] on:fromViewController withObject:toViewController withObject:completion])
        completion(YES);
}

- (void)bbPushViewController:(UIViewController *)toViewController animated:(BOOL)animated {
#if DISABLE_CUSTOM_TRANSITIONS
    [self pushViewController:toViewController animated:animated];
#if LOG_NAVIGATION_STACK
    [self logNavigationStack];
#endif
#else
    UIViewController *fromViewController = self.topViewController;

    if (fromViewController == toViewController) return;

    if ([self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePush animated:animated]) {
        [self pushViewController:toViewController animated:animated];
#if LOG_NAVIGATION_STACK
        [self logNavigationStack];
#endif
    } else {
        [toViewController view];
        __block BOOL completionExecuted = NO;

        void(^completion)(BOOL) = ^(BOOL completed){
            if (completionExecuted) {
                NSLog(@"Hey!!! You called this completion block more than once! Stop it!");
                return;
            } else {
                completionExecuted = YES;
            }
            [self pushViewController:toViewController animated:NO];
#if LOG_NAVIGATION_STACK
            [self logNavigationStack];
#endif
            [toViewController view]; // Ensure view is loaded before transitioning
            [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePush];
            fromViewController.view.userInteractionEnabled = YES;
        };

        if (fromViewController.isViewLoaded) {
            fromViewController.view.userInteractionEnabled = NO;
            [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePush completion:completion];
        } else {
            completion(YES);
        }
    }
#endif
}

- (void)bbPopViewControllerAnimated:(BOOL)animated {
#if DISABLE_CUSTOM_TRANSITIONS
    [self popViewControllerAnimated:animated];
#if LOG_NAVIGATION_STACK
    [self logNavigationStack];
#endif
#else

    UIViewController *fromViewController = self.topViewController;
    NSInteger inViewIndex = [self.viewControllers indexOfObject:fromViewController] - 1;

    if (inViewIndex < 0) return; // Do nothing if at root view controller

    UIViewController *toViewController = inViewIndex > -1 ? [self.viewControllers objectAtIndex:(NSUInteger) inViewIndex] : nil;

    __block BOOL completionExecuted = NO;

    void(^completion)(BOOL)  = ^(BOOL completed){
        if (completionExecuted) {
            NSLog(@"Hey!!! You called this completion block more than once! Stop it!");
            return;
        } else {
            completionExecuted = YES;
        }
        [self popViewControllerAnimated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
#if LOG_NAVIGATION_STACK
        [self logNavigationStack];
#endif
        [toViewController view]; // Ensure view is loaded before transitioning
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    fromViewController.view.userInteractionEnabled = NO;
    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop completion:completion];
#endif
}

- (void)bbPopToViewController:(UIViewController *)toViewController animated:(BOOL)animated {
#if DISABLE_CUSTOM_TRANSITIONS
    [self popToViewController:toViewController animated:animated];
#if LOG_NAVIGATION_STACK
    [self logNavigationStack];
#endif
#else

    UIViewController *fromViewController = self.topViewController;

    __block BOOL completionExecuted = NO;

    void(^completion)(BOOL)  = ^(BOOL completed){
        if (completionExecuted) {
            NSLog(@"Hey!!! You called this completion block more than once! Stop it!");
            return;
        } else {
            completionExecuted = YES;
        }
        [self popToViewController:toViewController animated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
#if LOG_NAVIGATION_STACK
        [self logNavigationStack];
#endif
        [toViewController view]; // Ensure view is loaded before transitioning
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    fromViewController.view.userInteractionEnabled = NO;
    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop completion:completion];
#endif
}

- (void)bbPopToRootViewControllerAnimated:(BOOL)animated {
#if DISABLE_CUSTOM_TRANSITIONS
    [self popToRootViewControllerAnimated:animated];
#if LOG_NAVIGATION_STACK
    [self logNavigationStack];
#endif
#else

    UIViewController *fromViewController = self.topViewController;
    UIViewController *toViewController = [self.viewControllers objectAtIndex:0];

    if (fromViewController == toViewController) return; // Do nothing if already at root view controller

    __block BOOL completionExecuted = NO;

    void(^completion)(BOOL)  = ^(BOOL completed){
        if (completionExecuted) {
            NSLog(@"Hey!!! You called this completion block more than once! Stop it!");
            return;
        } else {
            completionExecuted = YES;
        }
        [self popToRootViewControllerAnimated:[self useDefaultTransitionFrom:fromViewController to:toViewController navigationType:BBNavigationTypePop animated:animated]];
#if LOG_NAVIGATION_STACK
        [self logNavigationStack];
#endif
        [toViewController view]; // Ensure view is loaded before transitioning
        [self transitionTo:toViewController from:fromViewController action:BBNavigationTypePop];
    };

    fromViewController.view.userInteractionEnabled = NO;
    [self transitionFrom:fromViewController to:toViewController action:BBNavigationTypePop completion:completion];
#endif
}

@end