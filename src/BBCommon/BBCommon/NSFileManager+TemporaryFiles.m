//
//  Created by Brian Romanko on 11/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "NSFileManager+TemporaryFiles.h"


@implementation NSFileManager (TemporaryFiles)

- (NSString *)createTemporaryDirectory {
    // Create a unique directory in the system temporary directory
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    if (![self createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]) {
        return nil;
    }
    return path;
}

- (NSString *)createTemporaryFile {
    NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:guid];
    if (![self createFileAtPath:path contents:nil attributes:nil]) {
        return nil;
    }
    return path;
}

@end