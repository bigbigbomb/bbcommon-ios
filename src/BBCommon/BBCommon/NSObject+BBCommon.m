//
//  Created by Brian Romanko on 12/25/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSObject+BBCommon.h"


@implementation NSObject (BBCommon)

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 afterDelay:(NSTimeInterval)delay {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (sig) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
        [invocation setArgument:&p1 atIndex:2];
        [invocation setArgument:&p2 atIndex:3];
        [invocation setArgument:&p3 atIndex:4];
        [invocation performSelector:selector withObject:self afterDelay:delay];
        if (sig.methodReturnLength) {
            id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

@end