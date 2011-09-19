//
//  Created by Brian Romanko on 8/22/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

#define BBPredicate(...) [NSPredicate predicateWithFormat:__VA_ARGS__]

#define BBSortAscending(KEY) [[[NSSortDescriptor alloc] initWithKey:KEY ascending:YES] autorelease]
#define BBSortDescending(KEY) [[[NSSortDescriptor alloc] initWithKey:KEY ascending:NO] autorelease]

@interface BBQuery : NSObject {

@private
    NSFetchRequest *_fetchRequest;
    NSManagedObjectContext *_context;
}

@property (nonatomic, readonly, retain) NSFetchRequest *fetchRequest;

- (id)initWithEntityClass:(Class)entityClass managedObjectContext:(NSManagedObjectContext *)context;

- (BBQuery *)where:(NSPredicate *)predicate;
- (BBQuery *)orderBy:(NSSortDescriptor *)sortDescriptor, ... NS_REQUIRES_NIL_TERMINATION;
- (BBQuery *)fetchProperties:(NSString *)property, ... NS_REQUIRES_NIL_TERMINATION;
- (BBQuery *)prefetchRelationships:(NSString *)relationshipKeyPath, ... NS_REQUIRES_NIL_TERMINATION;
- (NSArray *)findAll:(NSError **)error;
- (id)findOne:(NSError **)error;



@end