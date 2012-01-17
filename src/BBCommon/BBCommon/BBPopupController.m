//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBPopupController.h"
#import "UIView+BBCommon.h"

@implementation BBPopupController

@synthesize delegate = _delegate;
@synthesize shimButton = _shimButton;
@synthesize currentPopup = _currentPopup;


- (UIViewController *)getParentViewController {
    UIView *currentView = self.delegate;
    while (currentView != nil && [currentView.nextResponder isKindOfClass:[UIView class]]) {
        currentView = (UIView *) currentView.nextResponder;
    }
    return (UIViewController *) [currentView nextResponder];
}

- (void)show {
    UIViewController *viewController = [self getParentViewController];
    DAssert(viewController != nil, @"BBPopupController must be a child of a ViewController");
    
    [viewController.view addSubview:self];
    if (UIInterfaceOrientationIsPortrait(viewController.interfaceOrientation)) {
        self.frame = CGRectMake(0, 0, BBW(viewController.view), BBH(viewController.view));
    } else {
        self.frame = CGRectMake(0, 0, BBH(viewController.view), BBW(viewController.view));
    }

    self.currentPopup = [self.delegate viewForPopupController:self];
    [self addSubview:self.currentPopup];
}

- (void)hide {
    [self.currentPopup removeFromSuperview];
    [self removeFromSuperview];
}

- (void)dismissPopup:(id)dismissPopup {
    [self hide];
}

- (void)styleUI {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.shimButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shimButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
    self.shimButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.shimButton addTarget:self action:@selector(dismissPopup:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.shimButton];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self styleUI];
    }

    return self;
}

- (void)dealloc {
    [_shimButton release];
    [_currentPopup release];
    [super dealloc];
}


@end