//
//  Created by Brian Romanko on 2/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIApplication+BBCommon.h"
#import "UIDevice+BBCommon.h"


@implementation UIApplication (BBCommon)

+(CGSize) currentSize {
    return [UIApplication sizeInOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

+ (CGRect)currentFrame {
    CGSize currentSize = [self currentSize];
    UIApplication *application = [UIApplication sharedApplication];
    return CGRectMake(0, MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height), currentSize.width, currentSize.height);
}

+ (CGRect)currentFrameWithStatusBar {
    return CGRectMake(
            [UIScreen mainScreen].applicationFrame.origin.x,
            [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].applicationFrame.size.height,
            [UIScreen mainScreen].applicationFrame.size.width,
            [UIScreen mainScreen].applicationFrame.size.height);
}


+(CGSize) sizeInOrientation:(UIInterfaceOrientation)orientation
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIApplication *application = [UIApplication sharedApplication];
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        size = CGSizeMake(size.height, size.width);
    }
    if (application.statusBarHidden == NO)
    {
        size.height -= MIN(application.statusBarFrame.size.width, application.statusBarFrame.size.height);
    }
    return size;
}

- (void)openMapsWithDirectionsTo:(CLLocationCoordinate2D)to {
    Class itemClass = [MKMapItem class];
    if (itemClass && [itemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
        toLocation.name = @"Destination";
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    } else {
        NSMutableString *mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
        [mapURL appendFormat:@"saddr=Current Location"];
        [mapURL appendFormat:@"&daddr=%f,%f", to.latitude, to.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mapURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    }
}


@end