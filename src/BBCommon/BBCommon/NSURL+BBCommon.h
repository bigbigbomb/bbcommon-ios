//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSURL (BBCommon)

/**
 Returns a new dictionary that contains a dictionary for the receivers query string.

 @return A new dictionary that contains a dictionary for the form encoded string.
 */
- (NSDictionary *)queryDictionary;

@end