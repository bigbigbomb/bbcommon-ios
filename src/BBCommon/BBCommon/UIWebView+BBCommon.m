//
//  Created by Brian Romanko on 2/25/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UIWebView+BBCommon.h"


@implementation UIWebView (BBCommon)

- (void)hideShadows {
    for(UIView *view in [[[self subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[UIImageView class]])
            view.hidden = YES;
    }
}

@end