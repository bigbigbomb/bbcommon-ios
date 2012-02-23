//
//  Created by Lee Fastenau on 2/17/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTableView.h"
#import "UIView+BBCommon.h"

@interface BBTableView ()
- (void)updateShim;

@end

@implementation BBTableView {
@private
    UIColor *_bottomFillColor;
}

@synthesize bottomFillColor = _bottomFillColor;
@synthesize shimView = _shimView;

- (void)setBottomFillColor:(UIColor *)aBottomFillColor {
    NonatomicRetainedSetToFrom(_bottomFillColor, aBottomFillColor);
    self.shimView.backgroundColor = aBottomFillColor;
}


- (void)updateShim {
    float fillHeight = BBH(self) - (self.contentSize.height - self.contentOffset.y + self.contentInset.bottom);
    if (_bottomFillColor != nil && fillHeight > 0 && self.alpha > 0) {
        self.shimView.hidden = NO;
        self.shimView.frame = CGRectMake(0, self.contentSize.height, BBW(self), fillHeight);
    } else {
        self.shimView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateShim];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        self.shimView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)] autorelease];
        [self addSubview:self.shimView];
    }

    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"frame"];
    [_bottomFillColor release];
    [_shimView release];
    [super dealloc];
}

@end