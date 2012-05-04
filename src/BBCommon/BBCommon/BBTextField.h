//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBLabelStyle.h"

@interface BBTextField : UITextField {

@private
    BBLabelStyle *_placeholderStyle;
    UIEdgeInsets _textInsets;
}

@property(nonatomic, retain) BBLabelStyle *placeholderStyle;
@property(nonatomic) UIEdgeInsets textInsets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

@end