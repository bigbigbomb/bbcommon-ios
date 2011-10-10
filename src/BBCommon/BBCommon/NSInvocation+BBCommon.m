//
//  Created by Brian Romanko on 10/7/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <objc/runtime.h>
#import "NSInvocation+BBCommon.h"


@implementation NSInvocation (BBCommon)

+ (id)invocationWithTarget:(NSObject*)targetObject selector:(SEL)selector {
    NSMethodSignature* sig = [targetObject methodSignatureForSelector:selector];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setTarget:targetObject];
    [inv setSelector:selector];
    return inv;
}

+ (id)invocationWithClass:(Class)targetClass selector:(SEL)selector {
    Method method = class_getInstanceMethod(targetClass, selector);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;

    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

+ (id)staticInvocationWithClass:(Class)targetClass selector:(SEL)selector {
    Method method = class_getClassMethod(targetClass, selector);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;

    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc->types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector {
    struct objc_method_description desc;
    BOOL required = YES;
    desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
    if (desc.name == NULL) {
        required = NO;
        desc = protocol_getMethodDescription(targetProtocol, selector, required, YES);
    }
    if (desc.name == NULL)
        return nil;

    NSMethodSignature* sig = [NSMethodSignature signatureWithObjCTypes:desc.types];
    NSInvocation* inv = [NSInvocation invocationWithMethodSignature:sig];
    [inv setSelector:selector];
    return inv;
}

@end