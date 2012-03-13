//
//  Created by Brian Romanko on 2/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIApplication+BBCommon.h"


@implementation UIApplication (BBCommon)

+(CGSize) currentSize
{
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGRect)currentFrame {
    CGSize currentSize = [self currentSize];
    UIApplication *application = [UIApplication sharedApplication];
    return CGRectMake(0, MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height), currentSize.width, currentSize.height);
}


+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

@end