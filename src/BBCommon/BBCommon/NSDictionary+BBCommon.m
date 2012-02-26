//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSString+BBCommon.h"

@implementation NSDictionary (BBCommon)

// Sourced from https://github.com/samsoffes/sstoolkit/

+ (NSDictionary *)dictionaryWithFormEncodedString:(NSString *)encodedString {
	if (!encodedString) {
		return nil;
	}

	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSArray *pairs = [encodedString componentsSeparatedByString:@"&"];

	for (NSString *kvp in pairs) {
		if ([kvp length] == 0) {
			continue;
		}

		NSRange pos = [kvp rangeOfString:@"="];
		NSString *key;
		NSString *val;

		if (pos.location == NSNotFound) {
			key = [kvp stringByUnescapingFromURLQuery];
			val = @"";
		} else {
			key = [[kvp substringToIndex:pos.location] stringByUnescapingFromURLQuery];
			val = [[kvp substringFromIndex:pos.location + pos.length] stringByUnescapingFromURLQuery];
		}

		if (!key || !val) {
			continue; // I'm sure this will bite my arse one day
		}

		[result setObject:val forKey:key];
	}
	return result;
}


@end