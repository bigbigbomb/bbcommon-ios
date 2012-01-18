//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@class BBLabelStyle;

@interface NSString (BBCommon)

+ (BOOL)isEmpty:(NSString *)string;

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle;

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle forWidth:(CGFloat)width;


@end