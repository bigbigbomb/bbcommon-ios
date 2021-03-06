//
//  BBKenBurnsView.m
//  BBCommon
//
//  Created by Lee Brenner on 2/27/12.
//  Copyright 2012 BigBig Bomb, LLC. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "BBKenBurnsView.h"
#import "UIView+BBCommon.h"
#import "UIImage+BBCommon.h"


@interface BBKenBurnsView ()
- (void)animateNextImage;

@end

@implementation BBKenBurnsView {
@private
    NSMutableArray *_images;
    UIImageView *_imageA;
    UIImageView *_imageB;
    UIImageView *_currentImage;
    UIImageView *_previousImage;
    int _currentImageIndex;
    bool _animating;
    float _durationMinimum;
    float _scaleMinimum;
    float _scaleMaximum;
    float _translateMinimum;
    float _translateMaximum;
    float _durationMaximum;
    float _duration;
}
@synthesize images = _images;
@synthesize imageA = _imageA;
@synthesize imageB = _imageB;
@synthesize durationMinimum = _durationMinimum;
@synthesize durationMaximum = _durationMaximum;
@synthesize scaleMinimum = _scaleMinimum;
@synthesize scaleMaximum = _scaleMaximum;
@synthesize translateMinimum = _translateMinimum;
@synthesize translateMaximum = _translateMaximum;

- (void)styleUI {
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];

    self.imageA = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, BBW(self), BBH(self))];
    self.imageA.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageA];
    self.imageB = [[UIImageView alloc] initWithFrame:self.imageA.frame];
    self.imageB.contentMode = UIViewContentModeCenter;
    [self addSubview:self.imageB];
    _currentImage = self.imageA;
}

- (void)processImages:(NSMutableArray *)imageArray {
    self.images = [NSMutableArray arrayWithCapacity:[imageArray count]];
    for (UIImage *i in imageArray){
        [self.images addObject:[i transparentBorderImage:1]];
    }
}

- (id)initWithFrame:(CGRect)frame andImages:(NSMutableArray *)images {
    self = [super initWithFrame:frame];
    if (self) {
        _animating = NO;
        _durationMinimum = 8.0;
        _durationMaximum = 13.0;
        _scaleMinimum = 1.0;
        _scaleMaximum = 1.15;
        _translateMinimum = -60.0;
        _translateMaximum = 60.0;
        [self processImages:images];
        [self styleUI];
    }

    return self;
}

- (void)prepareToAnimateNextImage{
    if (_animating)
        [self animateNextImage];
}

- (void)animateNextImage {
    _previousImage = _currentImage;
    _currentImage = _currentImage == self.imageA ? self.imageB : self.imageA;
    _currentImage.image = (UIImage *)[self.images objectAtIndex:_currentImageIndex];
    //get a new random image that is not the current one
    int temp = BBRndInt(0, [self.images count] - 1);

    while (temp == _currentImageIndex) {
        temp = BBRndInt(0, [self.images count] - 1);
    }
    _currentImageIndex = temp;

    [self bringSubviewToFront:_currentImage];
    _currentImage.transform = CGAffineTransformIdentity;
    CGAffineTransform startT = CGAffineTransformMakeTranslation(BBRndFloat(self.translateMinimum * 0.5, self.translateMaximum * 0.5), BBRndFloat(self.translateMinimum * 0.5, self.translateMaximum * 0.5));
    float startScale = BBRndFloat(self.scaleMinimum, self.scaleMaximum);
    CGAffineTransform startS = CGAffineTransformMakeScale(startScale, startScale);
    _currentImage.transform = CGAffineTransformConcat(startT, startS);

    //animate!
    [UIView animateWithDuration:1.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _currentImage.alpha = 1;
                     }
                     completion:nil];
    [UIView animateWithDuration:1.0
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _previousImage.alpha = 0;
                     }
                     completion:nil];

    _duration = BBRndFloat(self.durationMinimum, self.durationMaximum);
    float endScale = BBRndFloat(self.scaleMinimum, self.scaleMaximum);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:_duration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    CGAffineTransform translate = CGAffineTransformMakeTranslation(BBRndFloat(self.translateMinimum, self.translateMaximum), BBRndFloat(self.translateMinimum, self.translateMaximum));
    CGAffineTransform scale = CGAffineTransformMakeScale(endScale, endScale);
    _currentImage.transform = CGAffineTransformConcat(translate, scale);
    [UIView commitAnimations];

    if (_animating)
        [self performSelector:@selector(prepareToAnimateNextImage) withObject:nil afterDelay:_duration - 2];
}

- (void)startAnimating {
    if (!_animating && self.images != nil && [self.images count] > 0) {
        _animating = YES;
        _currentImageIndex = BBRndInt(0, [self.images count] - 1);
        [self animateNextImage];
    }
}

- (void)stopAnimating {
    if (_animating && self.images != nil && [self.images count] > 0) {
       [NSObject cancelPreviousPerformRequestsWithTarget:self];
        _animating = NO;
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             _currentImage.alpha = 0;
                         }
                         completion:nil];
    }
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

@end