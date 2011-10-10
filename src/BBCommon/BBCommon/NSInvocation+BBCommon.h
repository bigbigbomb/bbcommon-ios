//
//  Created by Brian Romanko on 10/7/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface NSInvocation (BBCommon)

+ (id)invocationWithTarget:(NSObject*)targetObject selector:(SEL)selector;
+ (id)invocationWithClass:(Class)targetClass selector:(SEL)selector;

+ (id)staticInvocationWithClass:(Class)targetClass selector:(SEL)selector;

+ (id)invocationWithProtocol:(Protocol*)targetProtocol selector:(SEL)selector;

@end