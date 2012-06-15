//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UINavigationController+BBCommon.h"
#import "BBTransitioningViewControllerProtocol.h"

@implementation UINavigationController (BBCommon)

- (void)transitionTo:(UIViewController *)toViewController from:(UIViewController *)fromViewController action:(BBTransitionActionType)actionType animated:(BOOL)animated {
    if ([toViewController respondsToSelector:@selector(transitionInFromViewController:action:)])
        [((id<BBTransitioningViewControllerProtocol>) toViewController) transitionInFromViewController:fromViewController action:actionType];
}

- (void)transitionFrom:(UIViewController *)fromViewController to:(UIViewController *)toViewController action:(BBTransitionActionType)actionType animated:(BOOL)animated finish:(void(^)())finishBlock {
    if ([fromViewController respondsToSelector:@selector(transitionOutToViewController:action:finish:)])
        [((id<BBTransitioningViewControllerProtocol>) fromViewController) transitionOutToViewController:toViewController action:BBTransitionActionTypePush finish:finishBlock];
    else
        finishBlock();
}

- (void)bbPushViewController:(UIViewController *)toViewController animated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;

    void(^finishBlock)()  = ^{
        [self pushViewController:toViewController animated:NO];
        [self transitionTo:toViewController from:fromViewController action:BBTransitionActionTypePush animated:animated];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBTransitionActionTypePush animated:animated finish:finishBlock];
}

- (void)bbPopViewControllerAnimated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;
    NSInteger inViewIndex = [self.viewControllers indexOfObject:fromViewController] - 1;

    if (inViewIndex < 0) return; // Do nothing if at root view controller

    UIViewController *toViewController = inViewIndex > -1 ? [self.viewControllers objectAtIndex:(NSUInteger) inViewIndex] : nil;

    void(^finishBlock)()  = ^{
        [self popViewControllerAnimated:NO];
        [self transitionTo:toViewController from:fromViewController action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBTransitionActionTypePop animated:animated finish:finishBlock];
}

- (void)bbPopToViewController:(UIViewController *)toViewController animated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;

    void(^finishBlock)()  = ^{
        [self popToViewController:toViewController animated:NO];
        [self transitionTo:toViewController from:fromViewController action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBTransitionActionTypePop animated:animated finish:finishBlock];
}

- (void)bbPopToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *fromViewController = self.topViewController;
    UIViewController *toViewController = [self.viewControllers objectAtIndex:0];

    if (fromViewController == toViewController) return; // Do nothing if already at root view controller

    void(^finishBlock)()  = ^{
        [self popToRootViewControllerAnimated:NO];
        [self transitionTo:toViewController from:fromViewController action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionFrom:fromViewController to:toViewController action:BBTransitionActionTypePop animated:animated finish:finishBlock];}

@end