//
//  Created by Lee Fastenau on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBLabelStyle.h"
#import "UILabel+BBCommon.h"

@implementation BBLabelStyle

@synthesize font = _font;
@synthesize color = _color;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize highlightedColor = _highlightedColor;


- (UILabel *)createLabelWithText:(NSString *)text frame:(CGRect)frame alignment:(UITextAlignment)alignment {
    UILabel *label = [UILabel labelWithText:text font:self.font frame:frame lineBreakMode:self.lineBreakMode alignment:alignment];
    [self applyStyle:label];
    return label;
}

- (UILabel *)createLabelWithText:(NSString *)text frame:(CGRect)frame {
    return [self createLabelWithText:text frame:frame alignment:UITextAlignmentLeft];
}

- (void)applyStyle:(UILabel *)label {
    label.font = self.font;
    label.textColor = self.color;
    label.highlightedTextColor = self.highlightedColor;
    label.lineBreakMode = self.lineBreakMode;
    label.shadowColor = self.shadowColor;
    label.shadowOffset = self.shadowOffset;
}

- (void)dealloc {
    [_font release];
    [_color release];
    [_shadowColor release];
    [_highlightedColor release];
    [super dealloc];
}

@end