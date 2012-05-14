//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BBModalDialogView : UIView

@property(nonatomic, retain) UIView *contentView;

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated;

- (void)dismissAndPerformBlock:(void (^)())block;


+ (void)presentDialog:(UIView *)view delay:(NSTimeInterval)delay block:(void (^)())block;

+ (void)presentDialog:(UIView *)view;


@end