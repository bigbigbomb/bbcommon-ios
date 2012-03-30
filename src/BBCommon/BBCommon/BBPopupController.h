//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum {
    BBPopupConstraintNone,
    BBPopupConstraintHorizontal,
    BBPopupConstraintVertical
} BBPopupConstraint;

@interface BBPopupController : UIView {

@private
    UIButton *_shimButton;
    UIView *_popupView;
}

@property(nonatomic, retain) UIButton *shimButton;

@property(nonatomic, retain) UIView *popupView;

@property(nonatomic, retain) UIView *relativeView;

@property(nonatomic) CGPoint relativeOffset;

@property(nonatomic) BBPopupConstraint constraint;

- (void)show;

- (void)hide;


- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView;

- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView relativeToView:(UIView *)relativeView constraint:(BBPopupConstraint)constraint;


- (void)toggle;
@end