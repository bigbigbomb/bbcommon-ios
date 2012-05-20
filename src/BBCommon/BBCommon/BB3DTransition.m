//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <CoreGraphics/CoreGraphics.h>
#import "BB3DTransition.h"


@implementation BB3DTransition

+ (void)flipInFromBottom:(UIView *)view {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = CGPointMake(0.5, 1);
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5);
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = 1.0 / -1000;
    startT = CATransform3DRotate(startT, 90 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = 1.0 / -1000;
                         endT = CATransform3DRotate(endT, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         view.layer.transform = CATransform3DIdentity;
                        view.layer.anchorPoint = oldAnchor;
                        view.layer.position = oldPosition;
                     }];
}

+ (void)flipInFromTop:(UIView *)view {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = CGPointMake(0.5, 0);
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5);
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = 1.0 / -1000;
    startT = CATransform3DRotate(startT, 90 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = 1.0 / -1000;
                         endT = CATransform3DRotate(endT, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         view.layer.transform = CATransform3DIdentity;
                        view.layer.anchorPoint = oldAnchor;
                        view.layer.position = oldPosition;
                     }];
}

+ (void)flipOutFromBottom:(UIView *)view {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = CGPointMake(0.5, 1);
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5);
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = 1.0 / -1000;
    startT = CATransform3DRotate(startT, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = 1.0 / -1000;
                         endT = CATransform3DRotate(endT, 90 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         view.layer.transform = CATransform3DIdentity;
                        view.layer.anchorPoint = oldAnchor;
                        view.layer.position = oldPosition;
                     }];
}

+ (void)flipOutFromTop:(UIView *)view {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = CGPointMake(0.5, 0);
    view.layer.position = CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5);
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = 1.0 / -1000;
    startT = CATransform3DRotate(startT, 0 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;

    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationCurveEaseIn
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = 1.0 / -1000;
                         endT = CATransform3DRotate(endT, 90 * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         view.layer.transform = CATransform3DIdentity;
                        view.layer.anchorPoint = oldAnchor;
                        view.layer.position = oldPosition;
                     }];
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

}

@end