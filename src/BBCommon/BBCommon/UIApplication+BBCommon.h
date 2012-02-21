//
//  Created by Brian Romanko on 2/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIApplication (BBCommon)

+(CGSize) currentSize;

+(CGRect) currentFrame;

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;

@end