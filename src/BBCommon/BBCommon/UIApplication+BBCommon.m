//
//  Created by Brian Romanko on 2/18/12.
//  Copyright 2011 BigBig Bomb, LLC. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "UIApplication+BBCommon.h"


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

- (void)openMapsWithDirectionsFrom:(CLLocationCoordinate2D)from to:(CLLocationCoordinate2D)to {
    NSMutableString *mapURL;
    if ([[UIDevice currentDevice] majorVersion] < 6) {
        mapURL = [NSMutableString stringWithString:@"http://maps.google.com/maps?"];
    } else {
        mapURL = [NSMutableString stringWithString:@"Maps://?"];
    }
    [mapURL appendFormat:@"saddr=%f,%f", from.latitude, from.longitude];
    [mapURL appendFormat:@"&daddr=%f,%f", to.latitude, to.longitude];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapURL]];
}


@end