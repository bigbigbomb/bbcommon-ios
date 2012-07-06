//
// Created by brian on 7/6/12.
//
//


#import <objc/runtime.h>
#import "UILabel+Animation.h"
#import "BBCommon.h"

static char kBBNumericAnimationCurrentValueKey;

@interface UILabel (_BBCommonAnimation)
@property (readwrite, nonatomic, retain, setter = bb_setNumericAnimationCurrentValue:) NSNumber *bb_numericAnimationCurrentValue;
@end

@implementation UILabel (_BBCommonAnimation)
@dynamic bb_numericAnimationCurrentValue;
@end


@implementation UILabel (Animation)

- (NSNumber *)bb_numericAnimationCurrentValue {
    return (NSNumber *)objc_getAssociatedObject(self, &kBBNumericAnimationCurrentValueKey);
}

- (void)bb_setNumericAnimationCurrentValue:(NSNumber *)numericAnimationCurrentValue {
    objc_setAssociatedObject(self, &kBBNumericAnimationCurrentValueKey, numericAnimationCurrentValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)animateScoreLabel:(NSTimer*)timer {
    NSTimeInterval startTime = [[timer.userInfo objectForKey:@"startTime"] doubleValue];
    NSTimeInterval duration = [[timer.userInfo objectForKey:@"duration"] doubleValue];
    NSString *formatString = [timer.userInfo objectForKey:@"formatString"];
    double from = [[timer.userInfo objectForKey:@"from"] doubleValue];
    double to = [[timer.userInfo objectForKey:@"to"] doubleValue];

    double t = MIN([[NSDate date] timeIntervalSince1970] - startTime, duration);
    NSLog(@"time passed: %f currValue:", t);
    double score = -[self.bb_numericAnimationCurrentValue doubleValue] *(t/=duration)*(t-2); // quad ease out
    NSLog(@"%f", score);
    score = MIN(to, MAX(from, score)); // clip to range
    self.bb_numericAnimationCurrentValue = [NSNumber numberWithDouble:score];
    self.text = [NSString stringWithFormat:formatString, score];
}

- (void)animateNumericValueFrom:(NSNumber *)from to:(NSNumber *)to duration:(NSTimeInterval)duration formatString:(NSString *)formatString {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
            from, @"from",
            to, @"to",
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"startTime",
            [NSNumber numberWithDouble:duration], @"duration",
            formatString, @"formatString",
            nil];
    NSTimer *scoreAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animateScoreLabel:) userInfo:userInfo repeats:YES];

    [self performBlock:^{
        [scoreAnimationTimer invalidate];
        self.text = [NSString stringWithFormat:formatString, to];
    } afterDelay:duration];
}

@end