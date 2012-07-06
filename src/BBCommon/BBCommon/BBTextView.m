//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BBTextView.h"

@interface BBTextView ()
@property(nonatomic, retain) UILabel *placeholderLabel;

@end

@implementation BBTextView
@synthesize placeholder = _placeholder;
@synthesize placeholderStyle = _placeholderStyle;
@synthesize placeholderLabel = _placeholderLabel;


- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = insets;
        [self setPlaceholder:@""];
        BBLabelStyle *placeholderStyle = [[BBLabelStyle alloc] init];
        [self setPlaceholderStyle:placeholderStyle];
        placeholderStyle.color = [UIColor lightGrayColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }

    return self;
}

- (void)textChanged:(NSNotification *)notification {
    if ([[self placeholder] length] == 0) return;

    if ([[self text] length] == 0) {
        [self.placeholderLabel setAlpha:1];
    } else {
        [self.placeholderLabel setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    if ([[self placeholder] length] > 0) {
        if (self.placeholderLabel == nil) {
            self.placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 9,
                    self.bounds.size.width - 18, 0)];
            self.placeholderLabel.lineBreakMode = UILineBreakModeWordWrap;
            self.placeholderLabel.numberOfLines = 0;
            self.placeholderLabel.font = self.placeholderStyle.font;
            self.placeholderLabel.backgroundColor = [UIColor clearColor];
            self.placeholderLabel.textColor = self.placeholderStyle.color;
            self.placeholderLabel.alpha = 0;
            [self addSubview:self.placeholderLabel];
        }

        self.placeholderLabel.text = self.placeholder;
        [self.placeholderLabel sizeToFit];
        [self sendSubviewToBack:self.placeholderLabel];
    }

    if ([[self text] length] == 0 && [[self placeholder] length] > 0) {
        [self.placeholderLabel setAlpha:1];
    }

    [super drawRect:rect];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_placeholderLabel release];
    [_placeholderStyle release];
    [_placeholder release];
    [super dealloc];
}

@end