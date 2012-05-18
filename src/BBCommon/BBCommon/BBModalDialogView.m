//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBModalDialogView.h"
#import "BBCommon.h"
#import "UIApplication+BBCommon.h"

@interface BBModalDialogView ()

@property(nonatomic, retain) UIView *contentContainer;
@property (nonatomic, retain) UIWindow *overlayWindow;

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated;

@end

@implementation BBModalDialogView

@synthesize contentView = _contentView;
@synthesize contentContainer = _contentContainer;
@synthesize overlayWindow = _overlayWindow;

static BBModalDialogView *sharedDialog = nil;


+ (BBModalDialogView *)presentDialog:(UIView *)view delay:(NSTimeInterval)delay block:(void (^)())block {
    [self presentDialog:view];

    [self performBlock:^{
        [[BBModalDialogView sharedDialog] dismissAndPerformBlock:block animated:NO];
    } afterDelay:delay];

    return [BBModalDialogView sharedDialog];
}

+ (BBModalDialogView *)presentDialog:(UIView *)view {
    [[BBModalDialogView sharedDialog].overlayWindow makeKeyAndVisible];
    [[BBModalDialogView sharedDialog] positionDialog:nil];
    [[BBModalDialogView sharedDialog] registerNotifications];
    [BBModalDialogView sharedDialog].contentView = view;
    return [BBModalDialogView sharedDialog];
}

+ (BBModalDialogView *)sharedDialog {
	if (sharedDialog == nil)
		sharedDialog = [[BBModalDialogView alloc] initWithFrame:[UIScreen mainScreen].bounds];

	return sharedDialog;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self styleUI];
    }

    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_contentView release];
    [_contentContainer release];
    [_overlayWindow release];
    [super dealloc];
}

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated {
    [_contentView removeFromSuperview];

    NonatomicRetainedSetToFrom(_contentView, contentView);
    [self.contentContainer addSubview:_contentView];
    self.contentContainer.hidden = YES;
    self.contentContainer.alpha = 0;

    [UIView setAnimationsEnabled:animated];
    self.contentContainer.hidden = NO;
    [UIView animateWithDuration:0.3
                   animations:^{
                       self.contentContainer.alpha = 1;
                   }];
    [UIView setAnimationsEnabled:YES];
}

- (void)setContentView:(UIView *)aContentView {
    [self setContentView:aContentView animated:YES];
}


- (void)styleUI {
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayWindow.userInteractionEnabled = YES;
    [self.overlayWindow addSubview:self];
    self.userInteractionEnabled = YES;

    self.contentContainer = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
    self.contentContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.contentContainer];
}

- (void)positionDialog:(NSNotification*)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
    }

    CGFloat activeHeight = orientationFrame.size.height;
    CGFloat posY = (CGFloat) floor(activeHeight * 0.45);
    CGFloat posX = orientationFrame.size.width/2;

    CGPoint newCenter;
    CGFloat rotateAngle;

    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = (CGFloat) M_PI;
            newCenter = CGPointMake(posX, orientationFrame.size.height-posY);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateAngle = (CGFloat) (-M_PI/2.0f);
            newCenter = CGPointMake(posY, posX);
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = (CGFloat) (M_PI/2.0f);
            newCenter = CGPointMake(orientationFrame.size.height-posY, posX);
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            newCenter = CGPointMake(posX, posY);
            break;
    }

    // TODO handle orientation change properly. Right now it positions offscreen
//    self.transform = CGAffineTransformMakeRotation(rotateAngle);
//    self.center = newCenter;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionDialog:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dismissAnimated:(BOOL)animated {
    [self dismissAndPerformBlock:nil animated:animated];
}

- (void)dismissAndPerformBlock:(void (^)())block animated:(BOOL)animated {
    [UIView setAnimationsEnabled:animated];
    self.contentContainer.hidden = NO;
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:0
                     animations:^{
                         self.contentContainer.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                        [self setContentView:nil];

                        [self performBlock:^{
                            [[NSNotificationCenter defaultCenter] removeObserver:sharedDialog];
                            [_overlayWindow release], _overlayWindow = nil;
                            [sharedDialog release], sharedDialog = nil;

                            // find the frontmost window that is an actual UIWindow and make it keyVisible
                             [[UIApplication sharedApplication].windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                 if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                 }
                             }];

                            if (block)
                                block();
                        } afterDelay:0.4];
                     }];
    [UIView setAnimationsEnabled:YES];
}


@end