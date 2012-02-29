//
//  Created by Brian Romanko on 2/29/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "UITableView+BBCommon.h"


@implementation UITableView (BBCommon)

- (void)reloadDataAndRestoreSelection {
    NSIndexPath *selectedPath = [self indexPathForSelectedRow];
    [self reloadData];
    if (selectedPath != nil)
        [self selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    NSLog(@"Set the position");
}

@end