//
//  Created by Brian Romanko on 2/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class CLLocation;

@interface UIApplication (BBCommon)

+(CGSize) currentSize;

+(CGRect) currentFrame;

+(CGRect) currentFrameWithStatusBar;

+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation;

-(void) openMapsWithDirectionsFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to;

- (void)openMapsWithDirectionsTo:(CLLocationCoordinate2D)to;


@end