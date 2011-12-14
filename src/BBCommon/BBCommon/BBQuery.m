//
//  Created by Brian Romanko on 8/22/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBQuery.h"

@interface BBQuery()

@property (nonatomic, retain) NSFetchRequest *fetchRequest;
@property (nonatomic, retain) NSManagedObjectContext *context;

@end


@implementation BBQuery

@synthesize fetchRequest = _fetchRequest;
@synthesize context = _context;


- (id)initWithEntityClass:(Class)entityClass managedObjectContext:(NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _fetchRequest = [[NSFetchRequest alloc] init];
        [_fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass(entityClass) inManagedObjectContext:context]];
        self.context = context;
    }

    return self;
}

- (void)dealloc {
    [_fetchRequest release];
    [_context release];
    [super dealloc];
}

- (BBQuery *)where:(NSPredicate *)predicate {
    [self.fetchRequest setPredicate:predicate];
    return self;
}

- (BBQuery *)orderBy:(NSSortDescriptor *)sortDescriptor, ... {
    va_list args;
    va_start(args, sortDescriptor);
    
    NSMutableArray *sortDescriptors = [[[NSMutableArray alloc] init] autorelease];
    for (NSSortDescriptor *descriptor = sortDescriptor; descriptor != nil; descriptor = va_arg(args, NSSortDescriptor *))
    {
        [sortDescriptors addObject:descriptor];
    }
    va_end(args);
    
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    return self;
}


- (BBQuery *)fetchProperties:(NSString *)property, ... {
    va_list args;
    va_start(args, property);
    
    [self.fetchRequest setResultType:NSDictionaryResultType];
    NSMutableArray *propertiesToFetch = [[NSMutableArray alloc] init];
    for (NSString *p = property; p != nil; p = va_arg(args, NSString *)) {
        [propertiesToFetch addObject:p];
    }
    va_end(args);
    
    [self.fetchRequest setPropertiesToFetch:propertiesToFetch];
    [propertiesToFetch release];
    
    return self;
}

- (BBQuery *)prefetchRelationships:(NSString *)relationshipKeyPath, ... {
    va_list args;
    va_start(args, relationshipKeyPath);
    
    [self.fetchRequest setReturnsObjectsAsFaults:NO];
    NSMutableArray *relationshipKeyPaths = [[NSMutableArray alloc] init];
    for (NSString *r = relationshipKeyPath; r != nil; r = va_arg(args, NSString *)) {
        [relationshipKeyPaths addObject:r];
    }
    va_end(args);
    
    [self.fetchRequest setRelationshipKeyPathsForPrefetching:relationshipKeyPaths];
    [relationshipKeyPaths release];
    
    return self;
}

- (NSUInteger)count:(NSError **)error {
    [self.fetchRequest setFetchLimit:0];
    return [self.context countForFetchRequest:self.fetchRequest error:error];
}

- (NSArray *)findAll:(NSError **)error {
    [self.fetchRequest setFetchLimit:0];
    return [self.context executeFetchRequest:self.fetchRequest error:error];
}

- (id)findOne:(NSError **)error {
    [self.fetchRequest setFetchLimit:1];
    return [[self.context executeFetchRequest:self.fetchRequest error:error] lastObject];
}


@end