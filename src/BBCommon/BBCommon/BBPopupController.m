//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBPopupController.h"
#import "UIView+BBCommon.h"

@implementation BBPopupController

@synthesize shimButton = _shimButton;
@synthesize popupView = _popupView;

- (void)show {
    self.hidden = NO;
}

- (void)hide {
    self.hidden = YES;
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
    self = [self initWithFrame:frame popupView:nil];
    if (self) {
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame popupView:(UIView *)popupView {
    self = [super initWithFrame:frame];
    if (self) {
        self.popupView = popupView;
        [self styleUI];
    }

    return self;
}

- (void)dealloc {
    [_shimButton release];
    [_popupView release];
    [super dealloc];
}

@end