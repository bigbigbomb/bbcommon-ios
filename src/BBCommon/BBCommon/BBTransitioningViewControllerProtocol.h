//
//  Created by Lee Fastenau on 6/13/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//

@protocol BBTransitioningViewControllerProtocol <NSObject>

@optional
    - (void)pushTransitionInFromViewController:(UIViewController *)viewController;
    - (void)popTransitionInFromViewController:(UIViewController *)viewController;
    - (void)pushTransitionOutToViewController:(UIViewController *)viewController finish:(void (^)())finish;
    - (void)popTransitionOutToViewController:(UIViewController *)viewController finish:(void (^)())finish;

@end