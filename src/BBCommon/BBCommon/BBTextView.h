//
//  Created by Brian Romanko on 6/1/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBLabelStyle.h"

@interface BBTextView : UITextView {

@private
    UIEdgeInsets _textInsets;
}

@property(nonatomic) UIEdgeInsets textInsets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets;

@end