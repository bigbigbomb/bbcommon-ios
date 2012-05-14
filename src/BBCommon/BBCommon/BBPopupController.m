//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBPopupController.h"
#import "UIView+BBCommon.h"

@implementation BBPopupController

@synthesize shimButton = _shimButton;
@synthesize popupView = _popupView;
@synthesize relativeView = _relativeView;
@synthesize relativeOffset = _relativeOffset;
@synthesize constraint = _constraint;


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGPoint newPoint = CGPointMake(BBX(self.relativeView)+self.relativeOffset.x, BBY(self.relativeView)+self.relativeOffset.y);
    if (self.constraint == BBPopupConstraintHorizontal)
        newPoint.y = BBY(self.popupView);
    else if (self.constraint == BBPopupConstraintVertical)
        newPoint.x = BBX(self.popupView);

    BBMoveFrame(self.popupView, newPoint.x, newPoint.y);
}

- (void)show {
    self.hidden = NO;
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{self.alpha = 1;}];
}

- (void)hide {
    [UIView animateWithDuration:0.1 animations:^{self.alpha = 0;} completion:^(BOOL completion){self.hidden = YES;}];
}

- (void)toggle {
    if (self.hidden) {
        [self show];
    } else {
        [self hide];
    }
}

- (void)dismissPopup:(id)dismissPopup {
    [self hide];
}

- (void)styleUI {
    self.hidden = YES;

    self.shimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shimButton.frame = CGRectMake(0, 0, BBW(self), BBH(self));
    self.shimButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.shimButton addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.shimButton];

    [self addSubview:self.popupView];
}

- (id)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame popupView:nil relativeToView:nil constraint:BBPopupConstraintNone];
    return self;
}

- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView {
    self = [self initWithFrame:frame popupView:popupView relativeToView:nil constraint:BBPopupConstraintNone];
    return self;
}

- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView relativeToView:(UIView *)relativeView constraint:(BBPopupConstraint)constraint {
    self = [super initWithFrame:frame];
    if (self) {
        self.popupView = popupView;
        self.constraint = constraint;
        [self styleUI];

        if (relativeView) {
            self.relativeView = relativeView;
            [self.relativeView addObserver:self forKeyPath:@"frame" options:0 context:nil];
            self.relativeOffset = CGPointMake(BBX(popupView) - BBX(relativeView), BBY(popupView) - BBY(relativeView));
        }
    }

    return self;
}

- (void)dealloc {
    [_relativeView removeObserver:self forKeyPath:@"frame"];
    [_shimButton release];
    [_popupView release];
    [_relativeView release];
    [super dealloc];
}

@end