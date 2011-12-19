//
//  Created by Brian Romanko on 12/16/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSString+BBCommon.h"


@implementation NSString (BBCommon)

+ (BOOL) isEmpty:(NSString *)string{
    return string == nil || [string isEqual:[NSNull null]] || [string length] == 0;
}

@end