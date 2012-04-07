//
//  Created by Brian Romanko on 2/26/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <sys/xattr.h>
#import "NSURL+BBCommon.h"
#import "NSDictionary+BBCommon.h"


@implementation NSURL (BBCommon)

// Sourced from https://github.com/samsoffes/sstoolkit/

- (NSDictionary *)queryDictionary {
	 return [NSDictionary dictionaryWithFormEncodedString:self.query];
}

- (BOOL)addSkipBackupAttribute {
    const char* filePath = [[self path] fileSystemRepresentation];

    const char* attrName = "com.apple.MobileBackup";
    u_int8_t attrValue = 1;

    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
    return result == 0;
}


@end