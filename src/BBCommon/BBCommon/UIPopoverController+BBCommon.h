//
//  Created by Brian Romanko on 3/21/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIPopoverController (BBCommon)

- (void)removeInnerShadow;
- (void)presentPopoverWithoutInnerShadowFromRect:(CGRect)rect
                                          inView:(UIView *)view
                        permittedArrowDirections:(UIPopoverArrowDirection)direction
                                        animated:(BOOL)animated;

- (void)presentPopoverWithoutInnerShadowFromBarButtonItem:(UIBarButtonItem *)item
                                 permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections
                                                 animated:(BOOL)animated;

@end