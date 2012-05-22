//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <Foundation/Foundation.h>

#define RADIANS( degrees ) ( degrees * M_PI / 180 )
#define DEGREES( radians ) ( radians * 180 / M_PI )

typedef enum {
    BB3DFlipInFromTop,
    BB3DFlipInFromBottom,
    BB3DFlipInFromLeft,
    BB3DFlipInFromRight,
    BB3DFlipOutFromTop,
    BB3DFlipOutFromBottom,
    BB3DFlipOutFromLeft,
    BB3DFlipOutFromRight
} BB3DFlipDirection;

typedef enum {
    BB3DSpinFromTop,
    BB3DSpinFromBottom,
    BB3DSpinFromLeft,
    BB3DSpinFromRight
} BB3DSpinDirection;

static float BB3DTopLeftRadianValues[] = {RADIANS(0), RADIANS(20), RADIANS(-90), RADIANS(90), RADIANS(-15), RADIANS(0)};
static float BB3DBottomRightRadianValues[] ={RADIANS(0), RADIANS(-20), RADIANS(90), RADIANS(-90), RADIANS(15), RADIANS(0)};

@interface BB3DTransition : NSObject

+ (void)flip:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection completion:(void(^)(BOOL finished))completion;
+ (void)spin:(UIView *)fromView toView:(UIView *)toView spinDirection:(BB3DSpinDirection)spinDirection fromViewCompletion:(void(^)(BOOL finished))fromViewCompletion toViewCompletion:(void(^)(BOOL finished))toViewCompletion;

+ (void)setPerspectiveAmount:(float)amount;
+ (float)getPerspectiveAmount;
+ (void)setFlipDuration:(float)duration;
+ (float)getFlipDuration;
+ (void)setSpinDuration:(float)duration;
+ (float)getSpinDuration;

@end


@interface BB3DTransitionResponder : NSObject

- (id)initWithBlock:(void (^)(BOOL))innerCompletion outerCompletion:(void (^)(BOOL))outerCompletion;

@end