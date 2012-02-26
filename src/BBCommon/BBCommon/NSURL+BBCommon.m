//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSURL+BBCommon.h"
#import "NSDictionary+BBCommon.h"


@implementation NSURL (BBCommon)

// Sourced from https://github.com/samsoffes/sstoolkit/

- (NSDictionary *)queryDictionary {
	 return [NSDictionary dictionaryWithFormEncodedString:self.query];
}

@end