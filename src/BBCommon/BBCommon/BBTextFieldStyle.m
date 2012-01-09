//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTextFieldStyle.h"
#import "BBTextField.h"


@implementation BBTextFieldStyle

@synthesize textStyle = _textStyle;
@synthesize placeholderStyle = _placeholderStyle;
@synthesize background = _background;
@synthesize contentHorizontalAlignment = _contentHorizontalAlignment;
@synthesize contentVerticalAlignment = _contentVerticalAlignment;
@synthesize textInsets = _textInsets;
@synthesize placeholder = _placeholder;

- (id)init {
    self = [super init];
    if (self) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    }

    return self;
}

- (BBTextField *)bbTextFieldWithFrame:(CGRect)frame {
    BBTextField *field = [[[BBTextField alloc] initWithFrame:frame andInsets:self.textInsets] autorelease];
    [self.textStyle applyStyleToTextField:field];
    field.contentVerticalAlignment = self.contentVerticalAlignment;
    field.contentHorizontalAlignment = self.contentHorizontalAlignment;
    field.placeholderStyle = self.placeholderStyle;
    field.background = self.background;
    field.placeholder = self.placeholder;
    return field;
}

- (void)dealloc {
    [_textStyle release];
    [_placeholderStyle release];
    [_background release];
    [_placeholder release];
    [super dealloc];
}
@end