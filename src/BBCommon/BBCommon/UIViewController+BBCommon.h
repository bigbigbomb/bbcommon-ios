//
//  Created by Brian Romanko on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol BBViewControllerDelegate;

/**
 * Category helper methods for UIViewController. Most of these methods support fluent programming or method chaining.
 */
@interface UIViewController(BBCommon)

/**
 * Sets the background of the current view controller to a screenshot image of the passed in view controller.
 * @param viewController The view controller from which the screenshot will be taken.
 */
- (UIViewController *)insertScreenshotOfControllerAsBackground:(UIViewController *)viewController;

/**
 * Displays a model view that supports transparent backgrounds
 */
- (void)bbPresentViewController:(UIViewController *)viewControllerToPresent;

/**
 * Dismisses the modal view
 */
- (void)bbDismissViewController;


@property (nonatomic, assign) id<BBViewControllerDelegate> bbViewControllerDelegate;

@end

@protocol BBViewControllerDelegate <NSObject>

@optional
- (void)viewControllerWillBePresented:(UIViewController *)viewController;
- (void)viewControllerDidGetPresented:(UIViewController *)viewController;
- (void)viewControllerWillBeDismissed:(UIViewController *)viewController;
- (void)viewControllerDidGetDismissed:(UIViewController *)viewController;


@end