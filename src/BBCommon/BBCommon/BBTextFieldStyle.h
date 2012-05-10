//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BBTextField;
@class BBLabelStyle;

@interface BBTextFieldStyle : NSObject {

@private
    BBLabelStyle *_textStyle;
    BBLabelStyle *_placeholderStyle;
    UIImage *_background;
    UIControlContentHorizontalAlignment _contentHorizontalAlignment;
    UIControlContentVerticalAlignment _contentVerticalAlignment;
    UIEdgeInsets _textInsets;
    NSString *_placeholder;
}

@property(nonatomic, retain) BBLabelStyle *textStyle;
@property(nonatomic, retain) BBLabelStyle *placeholderStyle;
@property(nonatomic, retain) UIImage *background;
@property(nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;
@property(nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property(nonatomic) UIEdgeInsets textInsets;
@property(nonatomic, retain) NSString *placeholder;

- (BBTextField *)bbTextFieldWithFrame:(CGRect)frame;

@end