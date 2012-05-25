//  Created by leebrenner on 5/25/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MKMapView (BBCommon)
- (void)optimalRegionForPoints:(CLLocationCoordinate2D)location1 location2:(CLLocationCoordinate2D):location2 regionBuffer:(float)regionBuffer animated:(BOOL)animated;
@end