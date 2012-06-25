//
//  Created by Brian Romanko on 12/25/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject (BBCommon)

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 afterDelay:(NSTimeInterval)delay;

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

- (id)tryPerformSelector:(SEL)selector;

- (id)tryPerformSelector:(SEL)selector withObject:(id)obj;

- (id)tryPerformSelector:(SEL)selector withObject:(id)object1 withObject:(id)object2;

@end