//
//  Created by Lee Fastenau on 8/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UILabel+BBCommon.h"
#import "UIView+BBCommon.h"

@implementation UILabel(BBCommon)

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment {
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.text = text;
    label.font = font;
    label.lineBreakMode = lineBreakMode;
    label.textAlignment = alignment;
        
    // resize
    if (frame.size.width == 0 || frame.size.height == 0) {
        if (frame.size.width == 0) {
            label.numberOfLines = 1;
        } else {
            // todo: Assumes wrapping on width provided - don't do this
            label.numberOfLines = 0;
        }
        [label sizeToFit];
        BBResizeFrame(label, frame.size.width == 0 ? BBW(label) : frame.size.width, frame.size.height == 0 ? BBH(label) : frame.size.height);
    }
    
    // adjust alignment
    if (BBW(label) != frame.size.width && alignment != UITextAlignmentLeft) {
        float xDelta = (frame.size.width - BBW(label)) / (alignment == UITextAlignmentCenter ? 2.0f : 1.0f);
        BBMoveFrame(label, BBX(label) + xDelta, BBY(label));
    }
    
#ifndef BB_DEBUG_LABELS
    label.backgroundColor = [UIColor clearColor];
#else
    label.backgroundColor = [UIColor colorWithRed:BBRnd green:BBRnd blue:BBRnd alpha:0.2];
#endif

    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode {
    return [self labelWithText:text font:font frame:frame lineBreakMode:lineBreakMode alignment:UITextAlignmentLeft];
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font {
    return [self labelWithText:text font:font frame:BBEmptyRect(0, 0) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
}

- (CGFloat)getFrameHeightWithMaxWidth:(CGFloat)maxWidth {
    return [UILabel getFrameHeightFromStringWithMaxHeight:self.text withFont:self.font withMaxWidth:maxWidth withMaxHeight:NSIntegerMax];
}

- (CGFloat)getFrameHeightWithMaxSize:(CGSize)maxSize {
    return [UILabel getFrameHeightFromStringWithMaxHeight:self.text withFont:self.font withMaxWidth:maxSize.width withMaxHeight:maxSize.height];
}

+ (CGFloat)getFrameHeightFromStringWithMaxHeight:(NSString *)string
						  withFont:(UIFont *)font
					  withMaxWidth:(CGFloat)maxWidth
					 withMaxHeight:(CGFloat)maxHeight {
	CGSize stringSize = [string sizeWithFont:font
						   constrainedToSize:CGSizeMake(maxWidth, maxHeight)
							   lineBreakMode:UILineBreakModeWordWrap];

	return stringSize.height;
}

@end