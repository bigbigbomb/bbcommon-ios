//
//  Created by Lee Fastenau on 2/24/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBRoundedRectView.h"


@implementation BBRoundedRectView

@synthesize color = _color;
@synthesize cornerRadii = _cornerRadii;
@synthesize roundingCorners = _roundingCorners;


- (void)setColor:(UIColor *)aColor {
    NonatomicRetainedSetToFrom(_color, aColor);
    [self setNeedsDisplay];
}

- (void)setCornerRadii:(CGSize)aCornerRadii {
    _cornerRadii = aCornerRadii;
    [self setNeedsDisplay];
}

- (void)setRoundingCorners:(UIRectCorner)aRoundingCorners {
    _roundingCorners = aRoundingCorners;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:self.roundingCorners cornerRadii:self.cornerRadii];
    [self.color setFill];
    [path fill];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.roundingCorners = UIRectCornerAllCorners;
        self.backgroundColor = [UIColor clearColor];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    }

    return self;
}


- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    [_color release];
    [super dealloc];
}


@end