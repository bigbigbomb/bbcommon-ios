//
//  Created by Brian Romanko on 8/22/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@class BBQuery;


@interface NSManagedObject(BBCommon)

+ (id) insertNewObjectInContext:(NSManagedObjectContext *)context;

+ (BBQuery *) queryInContext:(NSManagedObjectContext *)context;

@end