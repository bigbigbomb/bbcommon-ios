//
//  Created by Lee Fastenau on 1/9/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BBTextField;
@class BBLabelStyle;

@interface BBTextFieldStyle : NSObject

@property(nonatomic, retain) BBLabelStyle *textStyle;
@property(nonatomic, retain) BBLabelStyle *placeholderStyle;
@property(nonatomic, retain) UIImage *background;
@property(nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;
@property(nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
@property(nonatomic) UIEdgeInsets textInsets;
@property(nonatomic) UIEdgeInsets editingTextInsets;
@property(nonatomic, retain) NSString *placeholder;
@property(nonatomic, copy) void (^styleAsValid)(BBTextField *);
@property(nonatomic, copy) void (^styleAsInvalid)(BBTextField *);

- (BBTextField *)bbTextFieldWithFrame:(CGRect)frame;

@end