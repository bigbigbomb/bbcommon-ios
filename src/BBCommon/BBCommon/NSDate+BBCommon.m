//
//  Created by Brian Romanko on 12/14/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSDate+BBCommon.h"


@implementation NSDate (BBCommon)

-(NSString *)UTCString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:self];
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

- (NSString *)stringForTimeIntervalSinceNowIncludingSeconds:(BOOL)includeSeconds {
	return [NSDate stringForTimeInterval:[self timeIntervalSinceNow] includeSeconds:includeSeconds];
}

+ (NSString *)stringForTimeInterval:(NSTimeInterval)interval includeSeconds:(BOOL)includeSeconds {
    NSTimeInterval intervalInSeconds = fabs(interval);
    double intervalInMinutes = round(intervalInSeconds / 60.0);

    if (intervalInMinutes >= 0 && intervalInMinutes <= 1) {
        if (!includeSeconds) return intervalInMinutes <= 0 ? @"less than a minute" : @"1 minute";
        if (intervalInSeconds >= 0 && intervalInSeconds < 5) return [NSString stringWithFormat:@"less than %d seconds", 5];
        else if (intervalInSeconds >= 5 && intervalInSeconds < 10) return [NSString stringWithFormat:@"less than %d seconds", 10];
        else if (intervalInSeconds >= 10 && intervalInSeconds < 20) return [NSString stringWithFormat:@"less than %d seconds", 20];
        else if (intervalInSeconds >= 20 && intervalInSeconds < 40) return @"half a minute";
        else if (intervalInSeconds >= 40 && intervalInSeconds < 60) return @"less than a minute";
        else return @"1 minute";
    }
    else if (intervalInMinutes >= 2 && intervalInMinutes <= 44) return [NSString stringWithFormat:@"%.0f minutes", intervalInMinutes];
    else if (intervalInMinutes >= 45 && intervalInMinutes <= 89) return @"about 1 hour";
    else if (intervalInMinutes >= 90 && intervalInMinutes <= 1439) return [NSString stringWithFormat:@"about %.0f hours", round(intervalInMinutes / 60.0)];
    else if (intervalInMinutes >= 1440 && intervalInMinutes <= 2879) return @"1 day";
    else if (intervalInMinutes >= 2880 && intervalInMinutes <= 43199) return [NSString stringWithFormat:@"%.0f days", round(intervalInMinutes / 1440.0)];
    else if (intervalInMinutes >= 43200 && intervalInMinutes <= 86399) return @"about 1 month";
    else if (intervalInMinutes >= 86400 && intervalInMinutes <= 525599) return [NSString stringWithFormat:@"%.0f months", round(intervalInMinutes / 43200.0)];
    else if (intervalInMinutes >= 525600 && intervalInMinutes <= 1051199) return @"about 1 year";
    else
        return [NSString stringWithFormat:@"over %.0f years", floor(intervalInMinutes / 525600.0)];
}


@end