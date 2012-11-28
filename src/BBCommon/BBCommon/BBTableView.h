//
//  Created by Lee Fastenau on 2/17/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface BBTableView : UITableView {
@private
    BOOL _bottomFillViewHidden;
}

@property(nonatomic, strong) UIColor *bottomFillColor;
@property(nonatomic) BOOL bottomFillViewHidden;
@end