//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BBRoundedRectView : UIView

@property(nonatomic, retain) UIColor *color;
@property(nonatomic) CGSize cornerRadii;
@property(nonatomic) UIRectCorner roundingCorners;

@end