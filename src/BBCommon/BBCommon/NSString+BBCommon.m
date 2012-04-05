//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSString+BBCommon.h"
#import "BBLabelStyle.h"


@implementation NSString (BBCommon)

+ (BOOL) isEmpty:(id)string{
    return string == nil || string == [NSNull null] || [string length] == 0;
}

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle {
    return [self sizeWithFont:labelStyle.font];
}

- (CGSize)sizeWithBBLabelStyle:(BBLabelStyle *)labelStyle forWidth:(CGFloat)width {
    return [self sizeWithFont:labelStyle.font forWidth:width lineBreakMode:labelStyle.lineBreakMode];
}

#pragma mark - URL Escaping and Unescaping

- (NSString *)stringByEscapingForURLQuery {
	NSString *result = self;

	static CFStringRef leaveAlone = CFSTR(" ");
	static CFStringRef toEscape = CFSTR("\n\r:/=,!$&'()*+;[]@#?%");

	CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, leaveAlone,
																	 toEscape, kCFStringEncodingUTF8);

	if (escapedStr) {
		NSMutableString *mutable = [NSMutableString stringWithString:(NSString *)escapedStr];
		CFRelease(escapedStr);

		[mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
		result = mutable;
	}
	return result;
}


- (NSString *)stringByUnescapingFromURLQuery {
	NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}



@end