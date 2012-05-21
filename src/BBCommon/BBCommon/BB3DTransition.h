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

@interface BB3DTransition : NSObject

+ (void)flip:(UIView *)view withFlipDirection:(BB3DFlipDirection)flipDirection;
+ (void)flipFromBottom:(UIView *)fromView toView:(UIView *)toView;
+ (void)flipFromTop:(UIView *)fromView toView:(UIView *)toView;

@end