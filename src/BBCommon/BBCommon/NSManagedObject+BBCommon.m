//
//  Created by Brian Romanko on 8/22/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSManagedObject+BBCommon.h"
#import "BBQuery.h"


@implementation NSManagedObject(BBCommon)

+ (id)insertNewObjectInContext:(NSManagedObjectContext *)context {
    return [NSEntityDescription
                      insertNewObjectForEntityForName:NSStringFromClass(self)
                              inManagedObjectContext:context];
}

+ (BBQuery *)queryInContext:(NSManagedObjectContext *)context {
    return [[BBQuery alloc] initWithEntityClass:self managedObjectContext:context];
}

@end