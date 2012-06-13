//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UINavigationController+BBCommon.h"
#import "BBTransitioningViewControllerProtocol.h"

@implementation UINavigationController (BBCommon)

- (void)transitionIn:(UIViewController *)inView from:(UIViewController *)outView action:(BBTransitionActionType)actionType animated:(BOOL)animated {
    if ([inView respondsToSelector:@selector(transitionInFromViewController:action:)])
        [((id<BBTransitioningViewControllerProtocol>)inView) transitionInFromViewController:outView action:actionType];
}

- (void)transitionOut:(UIViewController *)outView to:(UIViewController *)inView action:(BBTransitionActionType)actionType animated:(BOOL)animated finish:(void(^)())finishBlock {
    if ([outView respondsToSelector:@selector(transitionOutToViewController:action:finish:)])
        [((id<BBTransitioningViewControllerProtocol>)outView) transitionOutToViewController:inView action:BBTransitionActionTypePush finish:finishBlock];
    else
        finishBlock();
}

- (void)bbPushViewController:(UIViewController *)inView animated:(BOOL)animated {
    UIViewController *outView = self.topViewController;

    void(^finishBlock)()  = ^{
        [self pushViewController:inView animated:NO];
        [self transitionIn:inView from:outView action:BBTransitionActionTypePush animated:animated];
    };

    [self transitionOut:outView to:inView action:BBTransitionActionTypePush animated:animated finish:finishBlock];
}

- (void)bbPopViewControllerAnimated:(BOOL)animated {
    UIViewController *outView = self.topViewController;
    NSInteger inViewIndex = [self.viewControllers indexOfObject:outView] - 1;

    if (inViewIndex < 0) return; // Do nothing if at root view controller

    UIViewController *inView = inViewIndex > -1 ? [self.viewControllers objectAtIndex:(NSUInteger) inViewIndex] : nil;

    void(^finishBlock)()  = ^{
        [self popViewControllerAnimated:NO];
        [self transitionIn:inView from:outView action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionOut:outView to:inView action:BBTransitionActionTypePop animated:animated finish:finishBlock];
}

- (void)bbPopToViewController:(UIViewController *)inView animated:(BOOL)animated {
    UIViewController *outView = self.topViewController;

    void(^finishBlock)()  = ^{
        [self popToViewController:inView animated:NO];
        [self transitionIn:inView from:outView action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionOut:outView to:inView action:BBTransitionActionTypePop animated:animated finish:finishBlock];
}

- (void)bbPopToRootViewControllerAnimated:(BOOL)animated {
    UIViewController *outView = self.topViewController;
    UIViewController *inView = [self.viewControllers objectAtIndex:0];

    if (outView == inView) return; // Do nothing if already at root view controller

    void(^finishBlock)()  = ^{
        [self popToRootViewControllerAnimated:NO];
        [self transitionIn:inView from:outView action:BBTransitionActionTypePop animated:animated];
    };

    [self transitionOut:outView to:inView action:BBTransitionActionTypePop animated:animated finish:finishBlock];}

@end