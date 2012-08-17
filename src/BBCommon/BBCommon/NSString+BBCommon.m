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

- (NSString *)abbreviatedState {
    static NSDictionary *abbreviations = nil;

    if (abbreviations == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"USStateAbbreviations" ofType:@"plist"];
        abbreviations = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }

    NSString *result = [abbreviations objectForKey:[self uppercaseString]];
    return result ? result : self;
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

+ (NSString *)shortDisplayForNumber:(double)number {
    double questionCount = number;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if (questionCount > 1000000) {
        // 1.2m
        questionCount = questionCount / 1000000.0;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 1;
        formatter.positiveSuffix = @"m";
    } else if (questionCount > 10000) {
        // 10k, 100k
        questionCount = questionCount / 1000.0;
        formatter.positiveSuffix = @"k";
    } else if (questionCount > 1000) {
        // 1.6k
        questionCount = questionCount / 1000.0;
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 1;
        formatter.positiveSuffix = @"k";
    }
    NSString *output = [formatter stringFromNumber:[NSNumber numberWithDouble:questionCount]];
    [formatter release];
    return output;
}


@end