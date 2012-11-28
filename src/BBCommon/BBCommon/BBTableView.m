//
//  Created by Lee Fastenau on 2/17/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTableView.h"
#import "UIView+BBCommon.h"

@interface BBTableView ()
@property(nonatomic, strong) UIView *bottomFillView;
- (void)updateShim;
@end

@implementation BBTableView {
@private
    UIColor *_bottomFillColor;
}

@synthesize bottomFillColor = _bottomFillColor;
@synthesize bottomFillView = _bottomFillView;
@synthesize bottomFillViewHidden = _bottomFillViewHidden;


- (void)setBottomFillColor:(UIColor *)aBottomFillColor {
    NonatomicRetainedSetToFrom(_bottomFillColor, aBottomFillColor);
    self.bottomFillView.backgroundColor = aBottomFillColor;
}


- (void)updateShim {
    float fillHeight = BBH(self) - (self.contentSize.height - self.contentOffset.y + self.contentInset.bottom);
    if (fillHeight > 0) {
        self.bottomFillView.frame = CGRectMake(0, self.contentSize.height, BBW(self), fillHeight);
        self.bottomFillView.hidden = self.bottomFillViewHidden;
    } else {
        self.bottomFillView.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateShim];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self addObserver:self forKeyPath:@"bottomFillViewHidden" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
        self.bottomFillView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        [self addSubview:self.bottomFillView];
    }

    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"bottomFillViewHidden"];
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"frame"];
}

@end