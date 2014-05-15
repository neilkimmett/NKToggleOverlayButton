//
//  NKOverlayView.m
//  Food(ness)
//
//  Created by Neil Kimmett on 31/03/2014.
//  Copyright (c) 2014 Marks & Spencer. All rights reserved.
//

#import "NKOverlayView.h"
#import "FXBlurView.h"

@interface NKOverlayView ()
@property (nonatomic, strong) FXBlurView *blurView;
@property (nonatomic, strong) UIView *blurTintView;
@end

@implementation NKOverlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        
        UIView *blurTintView = [[UIView alloc] init];
        blurTintView.alpha = 0.4f;
        [self addSubview:blurTintView];
        self.blurTintView = blurTintView;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        self.imageView = imageView;
        
        UILabel *label = [self newLabel];
        [self addSubview:label];
        self.textLabel = label;
        
        self.style = NKOverlayViewStyleDark;
    }
    return self;
}

#pragma mark - Animation
- (void)animateOnTransitionWithCompletion:(void (^)())completion
{
    if (!self.imageView.image) {
        self.imageView.image = [self overlayImageForOn:YES];
    }
    [self animateTransitionFromTransform:[self smallTransform]
                             toTransform:[self largeTransform]
                              completion:completion];
}

- (void)animateOffTransitionWithCompletion:(void (^)())completion
{
    if (!self.imageView.image) {
        self.imageView.image = [self overlayImageForOn:NO];
    }

    [self animateTransitionFromTransform:[self largeTransform]
                             toTransform:[self smallTransform]
                              completion:completion];
}

- (void)animateTransitionFromTransform:(CGAffineTransform)fromTransform
                           toTransform:(CGAffineTransform)toTransform
                            completion:(void (^)())completion
{
    if (self.blurView) {
        [self.blurView removeFromSuperview];
        self.blurView = nil;
    }
    FXBlurView *blurView = [[FXBlurView alloc] init];
    blurView.frame = [self boundsForOverlay];
    blurView.tintColor = [UIColor clearColor];

    blurView.underlyingView = self.window;
    
    [self insertSubview:blurView belowSubview:self.blurTintView];
    self.blurView = blurView;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = [self angleOfOrientation:orientation];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    
    fromTransform = CGAffineTransformConcat(fromTransform, rotation);
    toTransform = CGAffineTransformConcat(toTransform, rotation);
    
    self.alpha = 0.0f;
    self.transform = fromTransform;
    self.blurView.transform = CGAffineTransformMakeRotation(-angle);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = rotation;
    } completion:^(BOOL finished1) {
        [UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.transform = toTransform;
            self.alpha = 0.0;
        } completion:^(BOOL finished2) {
            if (completion) {
                completion();
            }
            [self removeFromSuperview];
        }];
    }];
}

- (CGAffineTransform)smallTransform
{
    return CGAffineTransformMakeScale(0.8f, 0.8f);
}

- (CGAffineTransform)largeTransform
{
    return CGAffineTransformMakeScale(1.2f, 1.2f);
}


#pragma mark - View creation

- (UILabel *)newLabel
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.font = [UIFont boldSystemFontOfSize:12];
    return label;
}

#pragma mark - Images
- (UIImage *)overlayImageForOn:(BOOL)isOn
{
    if (isOn) {
        return [[UIImage imageNamed:@"thin-tick"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    else {
        return [[UIImage imageNamed:@"thin-cross"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    switch (self.style) {
        case NKOverlayViewStyleDark:
        {
            self.imageView.tintColor = [UIColor whiteColor];
            self.textLabel.textColor = [UIColor whiteColor];
            self.blurTintView.backgroundColor = [UIColor blackColor];
        }
        break;
        case NKOverlayViewStyleLight:
        {
            self.imageView.tintColor = [UIColor blackColor];
            self.textLabel.textColor = [UIColor blackColor];
            self.blurTintView.backgroundColor = [UIColor whiteColor];
        }
        break;
    }
    self.bounds = [self boundsForOverlay];
    self.center = self.window.center;
    self.blurTintView.frame = self.bounds;
    self.blurView.frame = self.bounds;
    self.imageView.frame = [self frameForImageView];
    self.textLabel.frame = [self frameForTextLabel];
}

static const CGFloat kOverlaySize = 135;
static const CGFloat kLabelHeight = 40;

- (CGRect)frameForTextLabel
{
    CGFloat labelYOrigin = kOverlaySize * 0.7f;
    CGFloat labelPadding = 5;
    CGRect labelFrame = CGRectMake(labelPadding, labelYOrigin, kOverlaySize-2*labelPadding, kLabelHeight);

    return labelFrame;
}


- (CGRect)boundsForOverlay
{
    CGRect overlayBounds = CGRectMake(0, 0, kOverlaySize, kOverlaySize);
    return overlayBounds;
}

- (CGRect)frameForImageView
{
    return CGRectOffset([self boundsForOverlay], 0, -10);
}

#pragma mark - Rotation
- (CGFloat)angleOfOrientation:(UIInterfaceOrientation)orientation
{
    CGFloat angle;
    
    switch (orientation)
    {
        case UIInterfaceOrientationPortraitUpsideDown:
            angle = (CGFloat)M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            angle = (CGFloat)-M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            angle = (CGFloat)M_PI_2;
            break;
        default:
            angle = 0.0f;
            break;
    }
    
    return angle;
}


@end
