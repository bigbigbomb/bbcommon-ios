//
//  Created by Lee Fastenau on 2/17/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTableView.h"
#import "UIView+BBCommon.h"

@implementation BBTableView {
@private
    UIColor *_bottomFillColor;
}

@synthesize bottomFillColor = _bottomFillColor;

- (void)drawRect:(CGRect)rect {
    CGContextRef myContext = UIGraphicsGetCurrentContext();

    float fillHeight = BBH(self) - (self.contentSize.height - self.contentOffset.y + self.contentInset.bottom);

    if (_bottomFillColor != nil && fillHeight > 0 && self.alpha > 0) {
        CGContextSetFillColorWithColor(myContext, [_bottomFillColor CGColor]);
        CGContextFillRect(myContext, CGRectMake(0, self.contentSize.height, BBW(self), fillHeight));
    }
}

- (void)setContentOffset:(CGPoint)aContentOffset {
    [super setContentOffset:aContentOffset];
    [self setNeedsDisplay];
}

- (void)dealloc {
    [_bottomFillColor release];
    [super dealloc];
}

@end