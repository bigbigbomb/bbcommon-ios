//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol BBModalDialogViewDelegate;

@interface BBModalDialogView : UIView

@property(nonatomic, retain) UIView *contentView;

@property(nonatomic, assign) id <BBModalDialogViewDelegate> delegate;

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated;

- (void)dismissAndPerformBlock:(void (^)())block animated:(BOOL)animated;

- (void)dismissAnimated:(BOOL)animated;

+ (BBModalDialogView *)presentDialog:(UIView *)view delay:(NSTimeInterval)delay block:(void (^)())block;

+ (BBModalDialogView *)presentDialog:(UIView *)view;

+ (BBModalDialogView *)sharedDialog;

@end

@protocol BBModalDialogViewDelegate <NSObject>

- (void)willShowDialog:(BBModalDialogView *)dialogView withTransitionDuration:(float)transitionDuration;
- (void)willHideDialog:(BBModalDialogView *)dialogView withTransitionDuration:(float)transitionDuration;
- (float)getHideDelay;

@end