//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDictionary (BBCommon)

/**
 Returns a new dictionary that contains a dictionary for a form encoded string.

 @param encodedString A string of form encoded components.

 @return A new dictionary that contains a dictionary for the form encoded string, or `nil` if `encodedString` is an
 invalid representation of a dictionary.
 */
+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString;

@end