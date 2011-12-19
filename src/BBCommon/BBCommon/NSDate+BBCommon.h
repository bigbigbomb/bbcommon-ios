//
//  Created by Brian Romanko on 12/14/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDate (BBCommon)


- (NSString *)UTCString;

+ (NSDate *)fromUTCString:(NSString *)string;

- (NSString *)stringForTimeIntervalSinceNowIncludingSeconds:(BOOL)includeSeconds;

- (NSString *)stringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds;

@end