//
// Created by brian on 7/6/12.
//
//


#import <Foundation/Foundation.h>

@interface UILabel (Animation)

- (void)animateNumericValueFrom:(NSNumber *)from to:(NSNumber *)to duration:(NSTimeInterval)duration formatString:(NSString *)formatString;

@end