//
//  Created by Brian Romanko on 1/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIScrollView+BBCommon.h"


@implementation UIScrollView (BBCommon)

- (void)stopScrolling {
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

@end