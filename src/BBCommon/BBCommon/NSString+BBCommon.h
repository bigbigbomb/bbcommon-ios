//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@class BBLabelStyle;

@interface NSString (BBCommon)

@property (readonly) NSString *abbreviatedState;

+ (BOOL)isEmpty:(NSString *)string;

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle;

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle forWidth:(CGFloat)width;


///----------------------------------
/// @name URL Escaping and Unescaping
///----------------------------------

/**
 Returns a new string escaped for a URL query parameter.

 The following characters are escaped: `\n\r:/=,!$&'()*+;[]@#?%`. Spaces are escaped to the `+` character. (`+` is
 escaped to `%2B`).

 @return A new string escaped for a URL query parameter.

 @see stringByUnescapingFromURLQuery
 */
- (NSString *)stringByEscapingForURLQuery;

/**
 Returns a new string unescaped from a URL query parameter.

 `+` characters are unescaped to spaces.

 @return A new string escaped for a URL query parameter.

 @see stringByEscapingForURLQuery
 */
- (NSString *)stringByUnescapingFromURLQuery;


@end