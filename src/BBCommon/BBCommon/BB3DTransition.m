//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>
#import "BB3DTransition.h"

static float BB3DTopLeftRadianValues[] = {RADIANS(0), RADIANS(20), RADIANS(-90), RADIANS(90), RADIANS(-15), RADIANS(0)};
static float BB3DBottomRightRadianValues[] ={RADIANS(0), RADIANS(-20), RADIANS(90), RADIANS(-90), RADIANS(15), RADIANS(0)};
static char kBB3DOriginalAnchorPointXKey;
static char kBB3DOriginalAnchorPointYKey;
static char kBB3DOriginalPositionXKey;
static char kBB3DOriginalPositionYKey;

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
    if (![view.layer animationKeys]){
        objc_setAssociatedObject(view, &kBB3DOriginalAnchorPointXKey, [NSNumber numberWithFloat:view.layer.anchorPoint.x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalAnchorPointYKey, [NSNumber numberWithFloat:view.layer.anchorPoint.y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalPositionXKey, [NSNumber numberWithFloat:view.layer.position.x], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(view, &kBB3DOriginalPositionYKey, [NSNumber numberWithFloat:view.layer.position.y], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        view.layer.anchorPoint = anchorPoint;
        view.layer.position = position;
        CATransform3D startT = CATransform3DIdentity;
        startT.m34 = _perspectiveAmount;
        startT = CATransform3DRotate(startT, start, 1.0f, 0.0f, 0.0f);
        view.layer.transform = startT;
        view.hidden = NO;
    }
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
                             view.layer.anchorPoint = CGPointMake([(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalAnchorPointXKey) floatValue], [(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalAnchorPointYKey) floatValue]);
                             view.layer.position = CGPointMake([(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalPositionXKey) floatValue], [(NSNumber *)objc_getAssociatedObject(view, &kBB3DOriginalPositionYKey) floatValue]);
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

+ (void)spin:(UIView *)fromView toView:(UIView *)toView spinDirection:(BB3DSpinDirection)spinDirection fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    switch (spinDirection) {
        case BB3DSpinFromBottom:
            [BB3DTransition spinFromBottom:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromLeft:
            [BB3DTransition spinFromLeft:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromRight:
            [BB3DTransition spinFromRight:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
        case BB3DSpinFromTop:
            [BB3DTransition spinFromTop:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion];
            break;
    }
}

+ (void)fromViewAnimation:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion angleValues:(float *)angleValues effectX:(BOOL)effectX effectY:(BOOL)effectY{
    void(^block)(BOOL)  = ^(BOOL finished){
        fromView.userInteractionEnabled = YES;
            if (finished) {

                if (fromView != toView){
                    fromView.layer.transform = CATransform3DIdentity;
                    fromView.hidden = YES;
                    toView.hidden = NO;
                }

                if (fromViewCompletion)
                    fromViewCompletion(finished);

                [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:angleValues effectX:effectX effectY:effectY];
            }
        };
    if (![UIView areAnimationsEnabled]){
        block(YES);
        return;
    }
    BB3DTransitionResponder *frontResponder = [[BB3DTransitionResponder alloc] initWithBlock:block outerCompletion:fromViewCompletion];
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
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[0],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[1],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans,angleValues[2],effectX,effectY,0)],
                                               nil];
    frontAnimation.keyTimes             = [NSArray arrayWithObjects:
                                              [NSNumber numberWithFloat:0],
                                              [NSNumber numberWithFloat:0.7],
                                              [NSNumber numberWithFloat:1],
                                               nil];
    frontAnimation.timingFunctions      = [NSArray arrayWithObjects:
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                               nil];
    [fromView.layer addAnimation:frontAnimation forKey:@"transform"];
    fromView.userInteractionEnabled = NO;
}

+ (void)toViewAnimation:(UIView *)toView toViewCompletion:(void(^)(BOOL finished))toViewCompletion angleValues:(float *)angleValues effectX:(BOOL)effectX effectY:(BOOL)effectY{
    void(^block)(BOOL)  = ^(BOOL finished){
        toView.userInteractionEnabled = YES;
            if (finished)
                toView.layer.transform = CATransform3DIdentity;

            if (toViewCompletion)
                toViewCompletion(finished);
        };
    if (![UIView areAnimationsEnabled]){
        block(YES);
        return;
    }
    BB3DTransitionResponder *backResponder = [[BB3DTransitionResponder alloc] initWithBlock:block outerCompletion:toViewCompletion];
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
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[3],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[4],effectX,effectY,0)],
                                            [NSValue valueWithCATransform3D:CATransform3DRotate(tTrans2,angleValues[5],effectX,effectY,0)],
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
    toView.userInteractionEnabled = NO;
}

+ (void)spinFromBottom:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:YES effectY:NO];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:YES effectY:NO];
    }
}

+ (void)spinFromTop:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:YES effectY:NO];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:YES effectY:NO];
    }
}

+ (void)spinFromLeft:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:NO effectY:YES];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DTopLeftRadianValues effectX:NO effectY:YES];
    }
}

+ (void)spinFromRight:(UIView *)fromView toView:(UIView *)toView fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion {
    if (fromView){
        fromView.hidden = NO;
        if (fromView != toView){
            toView.hidden = YES;
        }
        [BB3DTransition fromViewAnimation:fromView toView:toView fromViewCompletion:fromViewCompletion toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:NO effectY:YES];
    }
    else {
        toView.hidden = NO;
        [BB3DTransition toViewAnimation:toView toViewCompletion:toViewCompletion angleValues:BB3DBottomRightRadianValues effectX:NO effectY:YES];
    }
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
    void (^_outerCompletion)(BOOL);
}

- (id)initWithBlock:(void (^)(BOOL))innerCompletion outerCompletion:(void (^)(BOOL))outerCompletion {
    self = [super init];
    if (self) {
        _innerCompletion = [innerCompletion copy];
        _outerCompletion = [outerCompletion copy];
    }
    return self;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (_innerCompletion)
        _innerCompletion(flag);
    if (_outerCompletion)
        _outerCompletion(flag);
}

@end