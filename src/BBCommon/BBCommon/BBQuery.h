//
//  Created by Brian Romanko on 8/22/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

#define BBPredicate(...) [NSPredicate predicateWithFormat:__VA_ARGS__]

#if !__has_feature(objc_arc)
#define BBSortAscending(KEY) [[[NSSortDescriptor alloc] initWithKey:KEY ascending:YES] autorelease]
#define BBSortDescending(KEY) [[[NSSortDescriptor alloc] initWithKey:KEY ascending:NO] autorelease]
#else
#define BBSortAscending(KEY) [[NSSortDescriptor alloc] initWithKey:KEY ascending:YES]
#define BBSortDescending(KEY) [[NSSortDescriptor alloc] initWithKey:KEY ascending:NO]
#endif

@interface BBQuery : NSObject {

@private
    NSFetchRequest *_fetchRequest;
    NSManagedObjectContext *_context;
}

@property (nonatomic, readonly, strong) NSFetchRequest *fetchRequest;

- (id)initWithEntityClass:(Class)entityClass managedObjectContext:(NSManagedObjectContext *)context;

- (BBQuery *)where:(NSPredicate *)predicate;
- (BBQuery *)orderBy:(NSSortDescriptor *)sortDescriptor, ... NS_REQUIRES_NIL_TERMINATION;
- (BBQuery *)fetchProperties:(NSString *)property, ... NS_REQUIRES_NIL_TERMINATION;
- (BBQuery *)prefetchRelationships:(NSString *)relationshipKeyPath, ... NS_REQUIRES_NIL_TERMINATION;

- (NSUInteger)count:(NSError **)error;
- (NSArray *)findAll:(NSError **)error;
- (id)findOne:(NSError **)error;



@end