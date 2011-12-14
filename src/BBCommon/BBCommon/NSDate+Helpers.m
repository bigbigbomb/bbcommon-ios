//
//  Created by Brian Romanko on 12/14/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSDate+Helpers.h"


@implementation NSDate (Helpers)

-(NSString *)UTCString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self];
    [dateFormatter release];
    return dateString;
}

+(NSDate *)fromUTCString:(NSString *)string {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }

    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}

@end