//  Created by leebrenner on 5/25/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved



#import "MKMapView+BBCommon.h"


@implementation MKMapView (BBCommon)

- (void)optimalRegionForPoints:(CLLocationCoordinate2D)location1 location2:(CLLocationCoordinate2D)location2 regionBuffer:(float)regionBuffer animated:(BOOL)animated {
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;

    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;

    topLeftCoord.longitude = fmin(topLeftCoord.longitude, fmin(location1.longitude, location2.longitude));
    topLeftCoord.latitude = fmax(topLeftCoord.latitude, fmax(location1.latitude, location2.latitude));
    bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, fmax(location1.longitude, location2.longitude));
    bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, fmin(location1.latitude, location2.latitude));

    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * regionBuffer;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * regionBuffer;
    region = [self regionThatFits:region];
    [self setRegion:region animated:animated];
}

@end