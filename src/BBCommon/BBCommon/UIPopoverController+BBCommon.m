//
//  Created by Brian Romanko on 3/21/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIPopoverController+BBCommon.h"

@implementation UIPopoverController (BBCommon)

- (void)presentPopoverWithoutInnerShadowFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)direction animated:(BOOL)animated
{
    [self presentPopoverFromRect:rect inView:view permittedArrowDirections:direction animated:animated];
    [self removeInnerShadow];
}

- (void)presentPopoverWithoutInnerShadowFromBarButtonItem:(UIBarButtonItem *)item
                                 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                                 animated:(BOOL)animated
{
    [self presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
    [self removeInnerShadow];
}

- (void)removeInnerShadow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    for (UIView *windowSubView in window.subviews) {
        if ([NSStringFromClass([windowSubView class]) isEqualToString:@"UIDimmingView"]) {
            for (UIView *dimmingViewSubviews in windowSubView.subviews) {
                for (UIView *popoverSubview in dimmingViewSubviews.subviews) {
                    if([NSStringFromClass([popoverSubview class]) isEqualToString:@"UIView"]) {
                        for (UIView *subviewA in popoverSubview.subviews) {
                            if ([NSStringFromClass([subviewA class]) isEqualToString:@"UILayoutContainerView"]) {
                                subviewA.layer.cornerRadius = 0;
                                subviewA.layer.backgroundColor = [UIColor clearColor].CGColor;
                            }
                            for (UIView *subviewB in subviewA.subviews) {
                                if ([NSStringFromClass([subviewB class]) isEqualToString:@"UIImageView"] ) {
                                    [subviewB removeFromSuperview];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@end