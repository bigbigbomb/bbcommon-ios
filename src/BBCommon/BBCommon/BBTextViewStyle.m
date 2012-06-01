//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTextViewStyle.h"
#import "BBTextView.h"


@implementation BBTextViewStyle

@synthesize textStyle = _textStyle;
@synthesize background = _background;
@synthesize textInsets = _textInsets;


- (BBTextView *)bbTextViewWithFrame:(CGRect)frame {
    BBTextView *view = [[BBTextView alloc] initWithFrame:frame andInsets:self.textInsets];
    [self.textStyle applyStyleToTextView:view];
    view.backgroundColor = [UIColor colorWithPatternImage:self.background];
    return view;
}

- (void)dealloc {
    [_textStyle release];
    [_background release];
    [super dealloc];
}
@end