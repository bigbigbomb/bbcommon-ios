//
//  Created by Lee Fastenau on 2/14/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef enum {
    BBEndCapStyleNone = 0,
    BBEndCapStyleTop = 1,
    BBEndCapStyleBottom = 2,
    BBEndCapStyleTopAndBottom = 3
} BBEndCapStyle;

#define BBEndCapStyleForRowOfTotalRows(ROW,TOTAL_ROWS) ((BBEndCapStyle)((ROW == 0 ? BBEndCapStyleTop : 0) + (ROW == (TOTAL_ROWS-1) ? BBEndCapStyleBottom : 0)))

@interface BBTableViewCell : UITableViewCell {
@private
    BBEndCapStyle _endCapStyle;
    NSMutableDictionary *_backgroundViews;    
    NSMutableDictionary *_selectedBackgroundViews;
}

@property(nonatomic, assign) BBEndCapStyle endCapStyle;

- (UIView *)backgroundViewForStyle:(BBEndCapStyle)endCapStyle;
- (UIView *)selectedBackgroundViewForStyle:(BBEndCapStyle)endCapStyle;
- (void)setBackgroundView:(UIView *)view forStyle:(BBEndCapStyle)endCapStyle;
- (void)setSelectedBackgroundView:(UIView *)view forStyle:(BBEndCapStyle)endCapStyle;


@end