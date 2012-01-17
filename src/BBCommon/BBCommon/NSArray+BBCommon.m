//
//  Created by Brian Romanko on 1/15/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSArray+BBCommon.h"


@implementation NSArray (BBCommon)

- (id)nextObject:(id)object {
    id nextObject = nil;
    NSUInteger questionIndex = [self indexOfObject:object];
    if ([self count] - 1 >  questionIndex)
        nextObject = [self objectAtIndex:questionIndex + 1];
    return nextObject;
}

- (id)previousObject:(id)object {
    id previousObject = nil;
    NSUInteger questionIndex = [self indexOfObject:object];
    if (questionIndex > 0)
        previousObject = [self objectAtIndex:questionIndex - 1];
    return previousObject;
}

@end