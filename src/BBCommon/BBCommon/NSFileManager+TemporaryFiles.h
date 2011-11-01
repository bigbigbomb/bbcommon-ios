//
//  Created by Brian Romanko on 11/1/11.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSFileManager (TemporaryFiles)

-(NSString *)createTemporaryDirectory;

-(NSString *)createTemporaryFile;


@end