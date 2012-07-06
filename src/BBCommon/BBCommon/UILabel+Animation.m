//
// Created by brian on 7/6/12.
//
//


#import <objc/runtime.h>
#import "UILabel+Animation.h"
#import "BBCommon.h"

@implementation UILabel (Animation)

//- (void)animateScoreLabel {
//    double t = MIN([[NSDate date] timeIntervalSince1970] - self.scoreAnimationStartTime, SCORE_ANIMATION_DURATION);
//    int score = (int) round(-[self.ANDIScore doubleValue] *(t/=SCORE_ANIMATION_DURATION)*(t-2)); // quad ease out
//    score = MIN(1000, MAX(0, score)); // clip to range
//    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
//}

- (void)animateScoreLabel:(NSTimer*)timer {
    NSTimeInterval startTime = [[timer.userInfo objectForKey:@"startTime"] doubleValue];
    NSTimeInterval duration = [[timer.userInfo objectForKey:@"duration"] doubleValue];
    double from = [[timer.userInfo objectForKey:@"from"] doubleValue];
    double to = [[timer.userInfo objectForKey:@"to"] doubleValue];
    NSString * (^formatBlock)(double) = [timer.userInfo objectForKey:@"formatBlock"];

    double t = MIN([[NSDate date] timeIntervalSince1970] - startTime, duration);
    t = t/duration;
    double currentValue = -to *t*(t-2); // quad ease out
    currentValue = MIN(to, MAX(from, currentValue)); // clip to range
    self.text = formatBlock(currentValue);
}

- (void)animateNumericValueFrom:(NSNumber *)from to:(NSNumber *)to duration:(NSTimeInterval)duration formatBlock:(NSString * (^)(double))formatBlock {
    NSString * (^formatBlockCopy)(double) = Block_copy(formatBlock);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
            from, @"from",
            to, @"to",
            [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]], @"startTime",
            [NSNumber numberWithDouble:duration], @"duration",
            formatBlockCopy, @"formatBlock",
            nil];
    NSTimer *scoreAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(animateScoreLabel:) userInfo:userInfo repeats:YES];
    Block_release(formatBlockCopy);

    [self performBlock:^{
        [scoreAnimationTimer invalidate];
        NSString * (^finalFormatBlock)(double) = [userInfo objectForKey:@"formatBlock"];
        self.text = finalFormatBlock([to doubleValue]);
    } afterDelay:duration];
}

@end