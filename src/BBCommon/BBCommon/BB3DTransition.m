//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>
#import "BB3DTransition.h"

static float _perspectiveAmount;
static float _flipDuration;
static float _spinDuration;

@implementation BB3DTransition

+ (void) initialize {
    if ([self class] == [NSObject class]) {
    }
    _perspectiveAmount = 1.0 / -500;
    _flipDuration = 0.2;
    _spinDuration = 0.75;
}

+ (void)flipAnimate:(UIView *)view withPoint:(CGPoint)anchorPoint withPosition:(CGPoint)position withStart:(float)start andEnd:(float)end completion:(void (^)(BOOL finished))completion {
    CGPoint oldAnchor = view.layer.anchorPoint;
    CGPoint oldPosition = view.layer.position;
    view.layer.anchorPoint = anchorPoint;
    view.layer.position = position;
    CATransform3D startT = CATransform3DIdentity;
    startT.m34 = _perspectiveAmount;
    startT = CATransform3DRotate(startT, start, 1.0f, 0.0f, 0.0f);
    view.layer.transform = startT;
    view.hidden = NO;
    [UIView animateWithDuration:_flipDuration
                          delay:0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         CATransform3D endT = CATransform3DIdentity;
                         endT.m34 = _perspectiveAmount;
                         endT = CATransform3DRotate(endT, end, 1.0f, 0.0f, 0.0f);
                         view.layer.transform = endT;
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             if (end != RADIANS(0)) {
                                 view.hidden = YES;
                             }
                             view.layer.transform = CATransform3DIdentity;
                             view.layer.anchorPoint = oldAnchor;
                             view.layer.position = oldPosition;
                             if (completion){
                                 completion(finished);
                             }
                         }
                     }];
}

+ (void)setPoints:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection andStart:(float)start andEnd:(float)end completion:(void(^)(BOOL finished))completion {
    switch (flipDirection) {
        case BB3DFlipInFromBottom:
        case BB3DFlipOutFromBottom:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0.5, 1) withPosition:CGPointMake(view.layer.position.x, view.layer.position.y + view.frame.size.height * 0.5) withStart:start andEnd:end completion:completion];
            break;
        case BB3DFlipInFromTop:
        case BB3DFlipOutFromTop:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0.5, 0) withPosition:CGPointMake(view.layer.position.x, view.layer.position.y - view.frame.size.height * 0.5) withStart:start andEnd:end completion:completion];
            break;
        case BB3DFlipInFromLeft:
        case BB3DFlipOutFromLeft:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(0, 0.5) withPosition:CGPointMake(view.layer.position.x - view.frame.size.width * 0.5, view.layer.position.y) withStart:start andEnd:end completion:completion];
            break;
        case BB3DFlipInFromRight:
        case BB3DFlipOutFromRight:
            [BB3DTransition flipAnimate:view withPoint:CGPointMake(1, 0.5) withPosition:CGPointMake(view.layer.position.x + view.frame.size.width * 0.5, view.layer.position.y) withStart:start andEnd:end completion:completion];
            break;
    }
}

+ (void)flip:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection completion:(void(^)(BOOL finished))completion {
    switch (flipDirection) {
        case BB3DFlipInFromBottom:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:RADIANS(90) andEnd:RADIANS(0) completion:completion];
            break;
        case BB3DFlipInFromLeft:
        case BB3DFlipInFromRight:
        case BB3DFlipInFromTop:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:RADIANS(-90) andEnd:RADIANS(0) completion:completion];
            break;
        case BB3DFlipOutFromBottom:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:RADIANS(0) andEnd:RADIANS(90) completion:completion];
            break;
        case BB3DFlipOutFromLeft:
        case BB3DFlipOutFromRight:
        case BB3DFlipOutFromTop:
            [BB3DTransition setPoints:view withFlipDirection:flipDirection andStart:RADIANS(0) andEnd:RADIANS(-90) completion:completion];
            break;
    }
}

+ (void)spinFromBottom:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView != toView){
        toView.hidden = YES;
    }
    BB3DTransitionResponder *frontResponder = [[BB3DTransitionResponder alloc] initWithBlock:^(BOOL finished){
        if (finished) {
            if (fromView != toView){
                fromView.layer.transform = CATransform3DIdentity;
                fromView.hidden = YES;
                toView.hidden = NO;
            }

            BB3DTransitionResponder *backResponder = [[BB3DTransitionResponder alloc] initWithBlock:^(BOOL finished){
                if (finished)
                    toView.layer.transform = CATransform3DIdentity;
            } fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            backAnimation.delegate             = backResponder;
            backAnimation.duration             = _spinDuration * 0.5;
            backAnimation.repeatCount          = 0;
            backAnimation.removedOnCompletion  = YES;
            backAnimation.autoreverses         = NO;
            backAnimation.fillMode             = kCAFillModeForwards;

            CATransform3D tTrans2                  = CATransform3DIdentity;
            tTrans2.m34                            = _perspectiveAmount;

            backAnimation.values               = [NSArray arrayWithObjects:
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2, RADIANS(-90),1,0,0)],
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,RADIANS(10),1,0,0)],
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,RADIANS(0),1,0,0)],
                                                       nil];
            backAnimation.keyTimes             = [NSArray arrayWithObjects:
                                                      [NSNumber numberWithFloat:0],
                                                      [NSNumber numberWithFloat:0.7],
                                                      [NSNumber numberWithFloat:1],
                                                       nil];
            backAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                                       nil];
            [toView.layer addAnimation:backAnimation forKey:@"transform"];
        }
    } fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
    CAKeyframeAnimation *frontAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    frontAnimation.delegate             = frontResponder;
    frontAnimation.duration             = _spinDuration * 0.5;
    frontAnimation.repeatCount          = 0;
    frontAnimation.removedOnCompletion  = YES;
    frontAnimation.autoreverses         = NO;
    frontAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans                  = CATransform3DIdentity;
    tTrans.m34                            = _perspectiveAmount;

    frontAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, RADIANS(0),1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,RADIANS(-25),1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,RADIANS(90),1,0,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.8],
                                              [NSNumber numberWithFloat:1],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];
}

+ (void)spinFromTop:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView != toView){
        toView.hidden = YES;
    }
    BB3DTransitionResponder *frontResponder = [[BB3DTransitionResponder alloc] initWithBlock:^(BOOL finished){
        if (finished) {
            if (fromView != toView){
                fromView.layer.transform = CATransform3DIdentity;
                fromView.hidden = YES;
                toView.hidden = NO;
            }

            BB3DTransitionResponder *backResponder = [[BB3DTransitionResponder alloc] initWithBlock:^(BOOL finished){
                if (finished)
                    toView.layer.transform = CATransform3DIdentity;
            } fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            CAKeyframeAnimation *backAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            backAnimation.delegate             = backResponder;
            backAnimation.duration             = _spinDuration* 0.5;
            backAnimation.repeatCount          = 0;
            backAnimation.removedOnCompletion  = YES;
            backAnimation.autoreverses         = NO;
            backAnimation.fillMode             = kCAFillModeForwards;

            CATransform3D tTrans2                  = CATransform3DIdentity;
            tTrans2.m34                            = _perspectiveAmount;

            backAnimation.values               = [NSArray arrayWithObjects:
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2, RADIANS(90),1,0,0)],
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,RADIANS(-10),1,0,0)],
                                                    [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,RADIANS(0),1,0,0)],
                                                       nil];
            backAnimation.keyTimes             = [NSArray arrayWithObjects:
                                                      [NSNumber numberWithFloat:0],
                                                      [NSNumber numberWithFloat:0.7],
                                                      [NSNumber numberWithFloat:1],
                                                       nil];
            backAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                                       nil];
            [toView.layer addAnimation:backAnimation forKey:@"transform"];
        }
    } fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
    CAKeyframeAnimation *frontAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    frontAnimation.delegate             = frontResponder;
    frontAnimation.duration             = _spinDuration * 0.5;
    frontAnimation.repeatCount          = 0;
    frontAnimation.removedOnCompletion  = YES;
    frontAnimation.autoreverses         = NO;
    frontAnimation.fillMode             = kCAFillModeForwards;

    CATransform3D tTrans                  = CATransform3DIdentity;
    tTrans.m34                            = _perspectiveAmount;

    frontAnimation.values               = [NSArray arrayWithObjects:
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans, RADIANS(0),1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,RADIANS(25),1,0,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,RADIANS(-90),1,0,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.8],
                                              [NSNumber numberWithFloat:1],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];
}

+ (void)setPerspectiveAmount:(float)amount {
    _perspectiveAmount = amount;
}

+ (float)getPerspectiveAmount {
    return _perspectiveAmount;
}

+ (void)setFlipDuration:(float)duration {
    _flipDuration = duration;
}

+ (float)getFlipDuration {
    return _flipDuration;
}

+ (void)setSpinDuration:(float)duration {
    _spinDuration = duration;
}

+ (float)getSpinDuration {
    return _spinDuration;
}


@end

@implementation BB3DTransitionResponder {

    void (^_innerCompletion)(BOOL);
    void (^_fromViewCompletion)(BOOL);
    void (^_toViewCompletion)(BOOL);
}

- (id)initWithBlock:(void (^)(BOOL))innerCompletion fromViewCompletion:(void (^)(BOOL))fromViewCompletion toViewCompletion:(void (^)(BOOL))toViewCompletion {
    self = [super init];
    if (self) {
        _innerCompletion = [innerCompletion copy];
        _fromViewCompletion = [fromViewCompletion copy];
        _toViewCompletion = [toViewCompletion copy];
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (_innerCompletion)
        _innerCompletion(flag);
    if (_fromViewCompletion)
        _fromViewCompletion(flag);
    if (_toViewCompletion)
        _toViewCompletion(flag);
}

@end