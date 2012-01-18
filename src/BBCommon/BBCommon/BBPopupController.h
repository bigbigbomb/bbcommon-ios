//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BBPopupController : UIView {

@private
    UIButton *_shimButton;
    UIView *_popupView;
}

@property(nonatomic, retain) UIButton *shimButton;

@property(nonatomic, retain) UIView *popupView;

- (void)show;

- (void)hide;


- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView;
@end