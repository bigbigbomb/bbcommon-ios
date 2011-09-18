//
//  Created by Lee Fastenau on 8/5/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>

#define BBLabelStyleDefinitionExt(NAME, FONT_NAME, FONT_SIZE, FONT_COLOR, FONT_LINEBREAKMODE, FONT_SHADOWCOLOR, FONT_SHADOWOFFSET)     \
+ (BBLabelStyle *)NAME {                                                                                                               \
    static BBLabelStyle *style = nil;                                                                                                  \
    if (!style) {                                                                                                                      \
        style = [[BBLabelStyle alloc] init];                                                                                           \
        style.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE];                                                                   \
        style.color = FONT_COLOR;                                                                                                      \
        if (FONT_LINEBREAKMODE) style.lineBreakMode = FONT_LINEBREAKMODE;                                                              \
        style.shadowColor = FONT_SHADOWCOLOR;                                                                                          \
        style.shadowOffset = FONT_SHADOWOFFSET;                                                                                        \
    }                                                                                                                                  \
    return style;                                                                                                                      \
}                                           
                                           
#define BBLabelStyleDefinition(NAME, FONT_NAME, FONT_SIZE, FONT_COLOR)                                                                 \
    BBLabelStyleDefinitionExt(NAME, FONT_NAME, FONT_SIZE, FONT_COLOR, UILineBreakModeTailTruncation, nil, CGSizeZero)

@interface BBLabelStyle : NSObject {

@private
    UIFont *_font;
    UIColor *_color;
    UILineBreakMode _lineBreakMode;
    UIColor *_shadowColor;
    CGSize _shadowOffset;
    
}

@property(nonatomic, retain) UIFont *font;
@property(nonatomic, retain) UIColor *color;
@property(nonatomic) UILineBreakMode lineBreakMode;
@property(nonatomic, retain) UIColor *shadowColor;
@property(nonatomic) CGSize shadowOffset;

- (UILabel *)createLabelWithText:(NSString *)text frame:(CGRect)frame alignment:(UITextAlignment)alignment; 
- (UILabel *)createLabelWithText:(NSString *)text frame:(CGRect)frame;
- (void)applyStyle:(UILabel *)label;

@end