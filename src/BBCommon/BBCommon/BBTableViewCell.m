//
//  Created by Lee Fastenau on 2/14/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import "BBTableViewCell.h"


@implementation BBTableViewCell
@synthesize endCapStyle = _endCapStyle;

- (UIView *)backgroundViewForStyle:(BBEndCapStyle)endCapStyle {
    return [_backgroundViews objectForKey:[NSNumber numberWithUnsignedInteger:endCapStyle]];
}

- (UIView *)selectedBackgroundViewForStyle:(BBEndCapStyle)endCapStyle {
    return [_selectedBackgroundViews objectForKey:[NSNumber numberWithUnsignedInteger:endCapStyle]];
}

- (void)setBackgroundView:(UIView *)view forStyle:(BBEndCapStyle)endCapStyle {
    [_backgroundViews setObject:view forKey:[NSNumber numberWithUnsignedInteger:endCapStyle]];
}

- (void)setSelectedBackgroundView:(UIView *)view forStyle:(BBEndCapStyle)endCapStyle {
    [_selectedBackgroundViews setObject:view forKey:[NSNumber numberWithUnsignedInteger:endCapStyle]];
}

- (void)setEndCapStyle:(BBEndCapStyle)anEndCapStyle {
    _endCapStyle = anEndCapStyle;
    
    UIView *background = [self backgroundViewForStyle:_endCapStyle];
    UIView *selectedBackground = [self selectedBackgroundViewForStyle:_endCapStyle];
    
    if (background == nil)
        background = [self backgroundViewForStyle:BBEndCapStyleNone];

    if (selectedBackground == nil)
        selectedBackground = [self selectedBackgroundViewForStyle:BBEndCapStyleNone];

    self.backgroundView = background;
    self.selectedBackgroundView = selectedBackground;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backgroundViews = [[NSMutableDictionary alloc] init];
        _selectedBackgroundViews = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)dealloc {
    [_backgroundViews release];
    [_selectedBackgroundViews release];
    [super dealloc];
}


@end