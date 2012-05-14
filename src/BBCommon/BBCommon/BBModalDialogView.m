//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBModalDialogView.h"
#import "BBRoundedRectView.h"
#import "BBCommon.h"

#define WINDOW_CORNER_RADIUS 10

@interface BBModalDialogView ()

@property(nonatomic, retain) UIView *windowView;
@property(nonatomic, retain) UIView *contentContainer;
@property(nonatomic, retain) UIImageView *oldViewScreenshot;
@property (nonatomic, retain) UIWindow *overlayWindow;

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated;

@end

@implementation BBModalDialogView

@synthesize contentView = _contentView;
@synthesize windowView = _windowView;
@synthesize contentContainer = _contentContainer;
@synthesize oldViewScreenshot = _oldViewScreenshot;
@synthesize overlayWindow = _overlayWindow;

static BBModalDialogView *sharedDialog = nil;


+ (void)presentDialog:(UIView *)view delay:(NSTimeInterval)delay block:(void (^)())block {
    [[BBModalDialogView sharedDialog].overlayWindow makeKeyAndVisible];
    [[BBModalDialogView sharedDialog] positionDialog:nil];
    [[BBModalDialogView sharedDialog] registerNotifications];
    [BBModalDialogView sharedDialog].contentView = view;

    [self performBlock:^{
        [[BBModalDialogView sharedDialog] dismissAndPerformBlock:block];
    } afterDelay:delay];
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
    [_windowView release];
    [_contentContainer release];
    [_oldViewScreenshot release];
    [_overlayWindow release];
    [super dealloc];
}

- (void)setContentView:(UIView *)contentView animated:(BOOL)animated {
    __block CGSize targetSize = CGSizeMake((contentView == nil ? 0 : BBW(contentView)) + WINDOW_CORNER_RADIUS * 2,(contentView == nil ? 0 : BBH(contentView)) + WINDOW_CORNER_RADIUS * 2);

    self.oldViewScreenshot.image = [_contentView getScreenshot];
    self.oldViewScreenshot.hidden = NO;
    self.oldViewScreenshot.alpha = 1;
    [_contentView removeFromSuperview];

    NonatomicRetainedSetToFrom(_contentView, contentView);
    [self.contentContainer addSubview:_contentView];
    self.contentContainer.hidden = YES;
    self.contentContainer.alpha = 0;

    // nil to view        = (fade out) -> 1 horizontal line -> 2 newView size -> 3 fade in
    // oldView to newView = 1 fade out   -> (oldView size)  -> 2 newView size -> 3 fade in
    // oldView to nil     = 1 fade out   -> (oldView size)  -> 2 center dot   -> 3 fade in
    // nil to nil = dumb

    [UIView setAnimationsEnabled:animated];
    [UIView animateWithDuration:0.15
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         if (self.oldViewScreenshot.image) {
                             self.oldViewScreenshot.alpha = 0;
                         } else {
                             self.windowView.frame = CGRectMake((BBW(self.superview) - targetSize.width) / 2, (BBH(self.superview) - WINDOW_CORNER_RADIUS * 2) / 2, targetSize.width, WINDOW_CORNER_RADIUS * 2);
                         }
                     }
                     completion:^(BOOL completion1){
                         if (completion1) {
                             self.oldViewScreenshot.hidden = YES;
                             [UIView animateWithDuration:0.3
                                                   delay:0
                                                 options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                                              animations:^{
                                                  self.windowView.frame = CGRectMake((BBW(self.superview) - targetSize.width) / 2, (BBH(self.superview) - targetSize.height) / 2, targetSize.width, targetSize.height);
                                              }
                                              completion:^(BOOL completion2){
                                                  if (completion2) {
                                                      self.contentContainer.hidden = NO;
                                                      [UIView animateWithDuration:0.3
                                                                       animations:^{
                                                                           self.contentContainer.alpha = 1;
                                                                       }];
                                                  }
                                              }];
                         }
                     }];
    [UIView setAnimationsEnabled:YES];
}

- (void)setContentView:(UIView *)aContentView {
    [self setContentView:aContentView animated:YES];
}


- (void)styleUI {
    _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.overlayWindow.backgroundColor = [UIColor clearColor];
    self.overlayWindow.userInteractionEnabled = YES;
    [self.overlayWindow addSubview:self];
    self.userInteractionEnabled = YES;

    self.windowView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, WINDOW_CORNER_RADIUS * 2, WINDOW_CORNER_RADIUS * 2)] autorelease];
    self.windowView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.windowView];
    [self.windowView horizontalAlignment:BBHorizontalAlignmentCenter verticalAlignment:BBVerticalAlignmentCenter];

    BBRoundedRectView *roundedRect = [[[BBRoundedRectView alloc] initWithFrame:CGRectMake(0, 0, BBW(self.windowView), BBH(self.windowView))] autorelease];
    roundedRect.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    roundedRect.color = [UIColor colorWithWhite:0 alpha:0.2];
    roundedRect.cornerRadii = CGSizeMake(WINDOW_CORNER_RADIUS, WINDOW_CORNER_RADIUS);
    [self.windowView addSubview:roundedRect];

    self.contentContainer = [[[UIView alloc] initWithFrame:CGRectMake(WINDOW_CORNER_RADIUS, WINDOW_CORNER_RADIUS, BBW(self.windowView)-WINDOW_CORNER_RADIUS*2, BBH(self.windowView)-WINDOW_CORNER_RADIUS*2)] autorelease];
    self.contentContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.windowView addSubview:self.contentContainer];

    self.oldViewScreenshot = [[[UIImageView alloc] initWithFrame:CGRectMake(WINDOW_CORNER_RADIUS, WINDOW_CORNER_RADIUS, BBW(self.windowView)-WINDOW_CORNER_RADIUS*2, BBH(self.windowView)-WINDOW_CORNER_RADIUS*2)] autorelease];
    self.oldViewScreenshot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.windowView addSubview:self.oldViewScreenshot];
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

    self.transform = CGAffineTransformMakeRotation(rotateAngle);
    self.center = newCenter;
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(positionDialog:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)dismissAndPerformBlock:(void (^)())block {
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
}


@end