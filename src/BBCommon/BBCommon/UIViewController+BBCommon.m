//
//  Created by Brian Romanko on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIViewController+BBCommon.h"
#import "UIView+BBCommon.h"

@implementation UIViewController(BBCommon)

- (UIViewController *)insertScreenshotOfControllerAsBackground:(UIViewController *)viewController {
    UIImageView *falseBackground = [[[UIImageView alloc] initWithImage:[viewController.view getScreenshot]] autorelease];
    [self.view insertSubview:falseBackground atIndex:0];
    BBResizeFrame(falseBackground, BBW(self.view), BBH(self.view));
    return self;
}

@end