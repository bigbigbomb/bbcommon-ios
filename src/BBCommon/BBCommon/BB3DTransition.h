//
//  ${FILE}
//  ${PRODUCT}
//
//  Created by leebrenner on 5/19/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <Foundation/Foundation.h>


@interface BB3DTransition : NSObject

+ (void)flipInFromBottom:(UIView *)view;
+ (void)flipInFromTop:(UIView *)view;
+ (void)flipOutFromBottom:(UIView *)view;
+ (void)flipOutFromTop:(UIView *)view;
+ (void)flipFromBottom:(UIView *)fromView toView:(UIView *)toView;
+ (void)flipFromTop:(UIView *)fromView toView:(UIView *)toView;

@end