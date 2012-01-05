//
//  Created by Lee Fastenau on 8/2/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIView+BBCommon.h"

@implementation UIView(BBCommon)

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when horizontally and vertically aligning a UIView [%@]", [self.class description]);
    BBMoveFrame(self, BBAlignedOrigin(horizontalAlignment, BBW(superview), BBW(self)), BBAlignedOrigin(verticalAlignment, BBH(superview), BBH(self)));
    return self;
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment verticalAlignment:(BBVerticalAlignment)verticalAlignment {
    return [self horizontalAlignment:horizontalAlignment verticalAlignment:verticalAlignment superview:self.superview];
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when horizontally aligning a UIView [%@]", [self.class description]);
    BBMoveFrame(self, BBAlignedOrigin(horizontalAlignment, BBW(superview), BBW(self)), BBY(self));
    return self;
}

- (UIView *)horizontalAlignment:(BBHorizontalAlignment)horizontalAlignment {
    return [self horizontalAlignment:horizontalAlignment superview:self.superview];
}

- (UIView *)verticalAlignment:(BBVerticalAlignment)verticalAlignment superview:(UIView *)superview {
    DAssert(superview, @"superview cannot be nil when vertically aligning a UIView [%@]", [self.class description]);
    BBMoveFrame(self, BBX(self), BBAlignedOrigin(verticalAlignment, BBH(superview), BBH(self)));
    return self;
}

- (UIView *)verticalAlignment:(BBVerticalAlignment)verticalAlignment {
    return [self verticalAlignment:verticalAlignment superview:self.superview];
}

- (UIView *)sizeToSubviews {
    CGSize newSize = CGSizeMake(0, 0);
    for (UIView *view in self.subviews) {
        newSize.width = MAX(newSize.width, BBX(view) + BBW(view));
        newSize.height = MAX(newSize.height, BBY(view) + BBH(view));
    }
    BBResizeFrame(self, newSize.width, newSize.height);
    return self;
}

- (void)addSpacer:(CGSize)size {
    UIView *spacer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [self addSubview:spacer];
    [spacer release];
}

- (UIImage *)getScreenshot{
    UIGraphicsBeginImageContext(self.frame.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (void)debugSizes {
    self.backgroundColor = [UIColor colorWithRed:BBRnd green:BBRnd blue:BBRnd alpha:0.2];
    for (UIView *subview in self.subviews)
        [subview debugSizes];
}

@end