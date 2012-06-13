//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//

typedef enum {
    BBTransitionActionTypePush,
    BBTransitionActionTypePop
} BBTransitionActionType;

@protocol BBTransitioningViewControllerProtocol <NSObject>

@optional
    - (void)transitionOutToViewController:(UIViewController *)viewController action:(BBTransitionActionType)actionType finish:(void (^)())finish;
    - (void)transitionInFromViewController:(UIViewController *)viewController action:(BBTransitionActionType)actionType;

@end