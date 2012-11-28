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
        __unsafe_unretained id p1uu = p1;
        __unsafe_unretained id p2uu = p2;
        __unsafe_unretained id p3uu = p3;
        [invocation setArgument:&p1uu atIndex:2];
        [invocation setArgument:&p2uu atIndex:3];
        [invocation setArgument:&p3uu atIndex:4];
        [invocation performSelector:selector withObject:self afterDelay:delay];
        if (sig.methodReturnLength) {
            __unsafe_unretained id anObject;
            [invocation getReturnValue:&anObject];
            return anObject;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)())block {
    block();
}

- (id)tryPerformSelector:(SEL)selector {
    if ([self respondsToSelector:selector])
        return [self performSelector:selector];
    else
        return nil;
}

- (id)tryPerformSelector:(SEL)selector withObject:(id)obj {
    if ([self respondsToSelector:selector])
        return [self performSelector:selector withObject:obj];
    else
        return nil;
}

- (id)tryPerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
    if ([self respondsToSelector:selector])
        return [self performSelector:selector withObject:object1 withObject:object2];
    else
        return nil;
}

@end