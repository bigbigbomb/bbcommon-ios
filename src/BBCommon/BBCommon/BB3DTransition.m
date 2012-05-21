//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <CoreGraphics/CoreGraphics.h>
#import "BB3DTransition.h"


@implementation BB3DTransition

+ (void)flipAnimate:(UIView *)view withPoint:(CGPoint)anchorPoint withPosition:(CGPoint)position withStart:(float)start andEnd:(float)end {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = anchorPoint;
    view.layer.position = position;
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = 1.0 / -1000;
    startT = CATransform3DRotate(startT, start, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = 1.0 / -1000;
                         endT = CATransform3DRotate(endT, end, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         view.layer.transform = CATransform3DIdentity;
                        view.layer.anchorPoint = oldAnchor;
                        view.layer.position = oldPosition;
                     }];
}

+ (void)flipInFromBottom:(UIView *)view {
    [BB3DTransition flipAnimate:view
                      withPoint:CGPointMake(0.5, 1)
                   withPosition:CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5)
                      withStart:RADIANS(90)
                         andEnd:RADIANS(0)];
}

+ (void)flipInFromTop:(UIView *)view {
    [BB3DTransition flipAnimate:view
                      withPoint:CGPointMake(0.5, 0)
                   withPosition:CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5)
                      withStart:RADIANS(90)
                         andEnd:RADIANS(0)];
}

+ (void)flipOutFromBottom:(UIView *)view {
    [BB3DTransition flipAnimate:view
                      withPoint:CGPointMake(0.5, 1)
                   withPosition:CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5)
                      withStart:RADIANS(0)
                         andEnd:RADIANS(90)];
}

+ (void)flipOutFromTop:(UIView *)view {
    [BB3DTransition flipAnimate:view
                      withPoint:CGPointMake(0.5, 0)
                   withPosition:CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5)
                      withStart:RADIANS(0)
                         andEnd:RADIANS(90)];
}

+ (void)flipFromBottom:(UIView *)fromView toView:(UIView *)toView {
    CAKeyframeAnimation *frontAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    frontAnimation.duration             = 0.75;
    frontAnimation.repeatCount          = 0;
    frontAnimation.removedOnCompletion  = YES;
    frontAnimation.autoreverses         = NO;
    frontAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans                  = CATransform3DIdentity;
    tTrans.m34                            = 1.0 / -100;

    frontAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, 0 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,-10 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,90 * M_PI / 180.0f,1,0,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0.0],
                                              [NSNumber numberWithFloat:0.35],
                                              [NSNumber numberWithFloat:0.5],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];

    CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    backAnimation.duration             = 0.75;
    backAnimation.repeatCount          = 0;
    backAnimation.removedOnCompletion  = YES;
    backAnimation.autoreverses         = NO;
    backAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans2                  = CATransform3DIdentity;
    tTrans2.m34                            = 1.0 / -100;

    backAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, -90 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,10 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,0 * M_PI / 180.0f,1,0,0)],
                                               nil];
    backAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0.5],
                                              [NSNumber numberWithFloat:0.85],
                                              [NSNumber numberWithFloat:1.0],
                                               nil];
    backAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [toView.layer addAnimation:backAnimation forKey:@"transform"];
}

+ (void)flipFromTop:(UIView *)fromView toView:(UIView *)toView {
    CAKeyframeAnimation *frontAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    frontAnimation.duration             = 0.75;
    frontAnimation.repeatCount          = 0;
    frontAnimation.removedOnCompletion  = YES;
    frontAnimation.autoreverses         = NO;
    frontAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans                  = CATransform3DIdentity;
    tTrans.m34                            = 1.0 / -100;

    frontAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, 0 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,10 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,-90 * M_PI / 180.0f,1,0,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0.0],
                                              [NSNumber numberWithFloat:0.35],
                                              [NSNumber numberWithFloat:0.5],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];

    CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    backAnimation.duration             = 0.75;
    backAnimation.repeatCount          = 0;
    backAnimation.removedOnCompletion  = YES;
    backAnimation.autoreverses         = NO;
    backAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans2                  = CATransform3DIdentity;
    tTrans2.m34                            = 1.0 / -100;

    backAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, 90 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,-10 * M_PI / 180.0f,1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,0 * M_PI / 180.0f,1,0,0)],
                                               nil];
    backAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0.5],
                                              [NSNumber numberWithFloat:0.85],
                                              [NSNumber numberWithFloat:1.0],
                                               nil];
    backAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [toView.layer addAnimation:backAnimation forKey:@"transform"];
}

@end