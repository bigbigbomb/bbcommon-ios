//
//  Created by Lee Fastenau on 1/12/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol BBPopupControllerDelegate;


@interface BBPopupController : UIView {

@private
    UIView <BBPopupControllerDelegate> *_delegate;
    UIButton *_shimButton;
    UIView *_currentPopup;
}

@property(assign) UIView <BBPopupControllerDelegate> *delegate;

@property(nonatomic, retain) UIButton *shimButton;

@property(nonatomic, retain) UIView *currentPopup;

- (void)show;
@end

@protocol BBPopupControllerDelegate <NSObject>

@required
    - (UIView *)viewForPopupController:(BBPopupController *)popupController;

@end