//
//  Created by Lee Fastenau on 1/11/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIButton+BBCommon.h"


@implementation UIButton (BBCommon)

+ (UIButton *)simpleButtonWithImageName:(NSString *)imageName origin:(CGPoint)origin {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:imageName];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    button.frame = CGRectMake(origin.x, origin.y, image.size.width, image.size.height);
    return button;
}

@end