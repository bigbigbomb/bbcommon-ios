//
// Created by brian on 9/27/12.
//
//


#import "UIDevice+BBCommon.h"


@implementation UIDevice (BBCommon)

- (NSInteger)majorVersion {
    return [[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
}

@end