//
//  Created by Lee Fastenau on 8/3/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

#define BBRnd ((arc4random()%256) / 255.0f)
//#define BB_DEBUG_LABELS

/**
 * Category helper methods for UILabel. Most of these methods support fluent programming or method chaining.
 */
@interface UILabel(BBCommon)

/*
 * Creates a label using the supplied text, frame, line break mode, and alignment. Setting the frame width and/or height to 0 will cause the label to autosize to the text's width and/or height, respectively.
 * This is pretty awesome, really. Because the autosizing will honor the supplied alignment and reposition your shit... err... stuff so that your text is registered properly.
 */
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode alignment:(UITextAlignment)alignment;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font frame:(CGRect)frame lineBreakMode:(UILineBreakMode)lineBreakMode;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font;

@end