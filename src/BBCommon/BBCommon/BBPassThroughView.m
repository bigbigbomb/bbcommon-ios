//  Created by leebrenner on 5/14/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import "BBPassThroughView.h"


@implementation BBPassThroughView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView * view in [self subviews]) {
        if ([view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}

@end