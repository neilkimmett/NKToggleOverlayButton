/*
 This file is part of NKToggleOverlayButton.
 
 Copyright (c) 2014, Neil Kimmett
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 *
 *
 * NKToggleOverlayButton.m
 *
 */


#define NK_IS_IOS7_OR_LATER NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1

#import "NKToggleOverlayButton.h"
#import "UIImage+ImageEffects.h"
#import "NKArchIndependentRounding.h"

@interface NKToggleOverlayButton()
{
    UIButton *_button;
    NSMutableDictionary *_onImagesForStates;
    NSMutableDictionary *_offImagesForStates;
}
@property (nonatomic, strong) UIAlertView *alertView;
- (void)animateOverlayView;

@end

@implementation NKToggleOverlayButton


- (id)init;
{
    self = [super init];
    if (self)
    {        
        // By default show the overlay animation
        _showOverlay = YES;
        
        // Instantiate dictionary used to store on/off images for different UIControlStates
        _onImagesForStates = [[NSMutableDictionary alloc] init];
        _offImagesForStates = [[NSMutableDictionary alloc] init];
        
        // Default images for overlay
        if (NK_IS_IOS7_OR_LATER) {
            _overlayOnImage = [UIImage imageNamed:@"thin-tick"];
            _overlayOffImage = [UIImage imageNamed:@"thin-cross"];
        }
        else {
            _overlayOnImage = [UIImage imageNamed:@"tick"];
            _overlayOffImage = [UIImage imageNamed:@"cross"];
        }
        
        self.accessibilityTraits = UIAccessibilityTraitButton;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_titleLabel];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.contentMode = UIViewContentModeScaleAspectFit;
        _button.adjustsImageWhenHighlighted = NO;
        [self addSubview:_button];
        
        [_button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
        [_button addTarget:self action:@selector(didTouchUpOutsideButton:) forControlEvents:UIControlEventTouchUpOutside];
        [_button addTarget:self action:@selector(didTouchDownButton:) forControlEvents:UIControlEventTouchDown];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self assignButtonImagesForStates];
    
    _button.frame = self.bounds;
    self.titleLabel.frame = self.bounds;
    [self bringSubviewToFront:self.titleLabel];
    
    _button.accessibilityLabel = self.accessibilityLabel;
    _button.accessibilityHint = self.accessibilityHint;
    _button.accessibilityTraits = self.accessibilityTraits;
}

#pragma mark -
#pragma mark Button image handling

- (void)setOnImage:(UIImage *)image forState:(UIControlState)state
{
    if (self.isSelected) {
        [_button setImage:image forState:state];
    }
    [_onImagesForStates setObject:image forKey:@(state)];
}

- (void)setOffImage:(UIImage *)image forState:(UIControlState)state;
{
    if (!self.isSelected) {
        [_button setImage:image forState:state];
    }
    [_offImagesForStates setObject:image forKey:@(state)];
}

- (void)assignButtonImagesForStates
{
    NSDictionary *states = self.isSelected ? _onImagesForStates : _offImagesForStates;
    // Set the appropriate images for our button
    [states enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIImage *image, BOOL *stop) {
         UIControlState state = (UIControlState)[key intValue];
         [_button setImage:image forState:state];
     }];
}

#pragma mark - Toggling

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self assignButtonImagesForStates];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setSelected:selected];

    [self performActions];
    
    if (animated) {
        [self animateOverlayView];
    }
}

- (void)toggleSelectedAnimated:(BOOL)animated
{
    [self setSelected:!self.isSelected animated:animated];
}


#pragma mark - Target/action

- (void)performActions
{
    NKToggleActionBlock actionBlock;
    if (self.isSelected) {
        actionBlock = self.toggleOnBlock;
        self.accessibilityTraits = UIAccessibilityTraitButton | UIAccessibilityTraitSelected;
    }
    else {
        actionBlock = self.toggleOffBlock;
        self.accessibilityTraits = UIAccessibilityTraitButton;
    }

    if (actionBlock) {
        actionBlock(self);
    }
}

- (void)didTouchUpInsideButton:(UIButton *)button
{
    [self setSelected:!self.isSelected animated:YES];
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)didTouchUpOutsideButton:(UIButton *)button
{
    [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}

- (void)didTouchDownButton:(UIButton *)button
{
    [self sendActionsForControlEvents:UIControlEventTouchDown];
}


#pragma mark - Animation

- (void)animateOverlayView
{
    if (!self.showOverlay) return;

    self.userInteractionEnabled = NO;

    UIView *overlayView = [self newOverlayView];
    [self.window addSubview:overlayView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:overlayView.bounds];
    iconView.contentMode = UIViewContentModeCenter;
    [overlayView addSubview:iconView];

    UILabel *label = [self newLabel];
    [overlayView addSubview:label];
    
    if (self.isSelected) {
        label.text = self.overlayOnText;
        iconView.image = self.overlayOnImage;

        [self animateOnTransitionWithOverlay:overlayView];
    }
    else {
        label.text = self.overlayOffText;
        iconView.image = self.overlayOffImage;

        [self animateOffTransitionWithOverlay:overlayView];
    }
}

- (void)animateOnTransitionWithOverlay:(UIView *)overlayView
{
    [self animateTransitionFromTransform:[self smallTransform]
                             toTransform:[self largeTransform]
                             withOverlay:overlayView];
}

- (void)animateOffTransitionWithOverlay:(UIView *)overlayView
{
    [self animateTransitionFromTransform:[self largeTransform]
                             toTransform:[self smallTransform]
                             withOverlay:overlayView];
}

- (void)animateTransitionFromTransform:(CGAffineTransform)fromTransform
                           toTransform:(CGAffineTransform)toTransform
                           withOverlay:(UIView *)overlayView
{
    overlayView.transform = fromTransform;

    [UIView animateWithDuration:0.3 animations:^{
        overlayView.alpha = 1.0;
        overlayView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished1) {
        [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            overlayView.transform = toTransform;
            overlayView.alpha = 0.0;
        } completion:^(BOOL finished2) {
            [overlayView removeFromSuperview];
            self.userInteractionEnabled = YES;
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

- (UIView *)newOverlayView
{
    CGRect overlayFrame = [self frameForOverlay];

    UIView *overlayView;
    if (NK_IS_IOS7_OR_LATER) {
        overlayView = [self newBlurredOverlayViewBackground];
    }
    else {
        overlayView = [[UIView alloc] initWithFrame:overlayFrame];
        overlayView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        overlayView.layer.cornerRadius = 12.0;
    }

    overlayView.alpha = 0.2;
    return overlayView;
}

- (UIView *)newBlurredOverlayViewBackground
{
    UIGraphicsBeginImageContext(self.window.bounds.size);
    [self.window drawViewHierarchyInRect:self.window.bounds afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    snapshotImage = [snapshotImage applyExtraLightEffect];
    UIImageView *snapshotView = [[UIImageView alloc] initWithImage:snapshotImage];
    [self.window addSubview:snapshotView];

    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor whiteColor].CGColor;
    maskLayer.frame = self.window.bounds;
    CGRect maskRect = [self frameForOverlay];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:maskRect cornerRadius:8].CGPath;
    snapshotView.layer.mask = maskLayer;
    return snapshotView;
}

- (UILabel *)newLabel
{
    CGRect labelFrame = [self frameForTextLabel];

    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    label.textColor = NK_IS_IOS7_OR_LATER ? [UIColor blackColor] : [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.adjustsFontSizeToFitWidth = YES;

    NSUInteger fontSize = 14;
    NSUInteger minFontSize = 8;
    label.font = [UIFont boldSystemFontOfSize:fontSize];
    if ([label respondsToSelector:@selector(setMinimumScaleFactor:)]) {
        float minScaleFactor = (float)minFontSize/(float)fontSize;
        [label setMinimumScaleFactor:minScaleFactor];
    }
    else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
        [label setMinimumFontSize:minFontSize];
#pragma clang diagnostic pop
    }
    return label;
}


#pragma mark - Layout

static const CGFloat kOverlaySize = 135;
- (CGRect)frameForOverlay
{
    CGFloat overlayXOrigin = nk_floor((self.window.bounds.size.width- kOverlaySize)/2.0f);
    CGFloat overlayYOrigin = nk_floor((self.window.bounds.size.height- kOverlaySize)/2.0f);
    CGRect overlayFrame = CGRectMake(overlayXOrigin, overlayYOrigin, kOverlaySize, kOverlaySize);
    return overlayFrame;
}

- (CGRect)frameForTextLabel
{
    CGFloat labelYOrigin = nk_floor(kOverlaySize - kOverlaySize /5.0f);
    CGFloat labelPadding = 5;
    CGRect labelFrame = CGRectMake(labelPadding, labelYOrigin, kOverlaySize-2* labelPadding, 15);
    // On iOS7+ our overlay is actually the size of the whole window, and is masked out
    if (NK_IS_IOS7_OR_LATER) {
        labelFrame.origin.x += (self.window.frame.size.width - kOverlaySize) / 2.0f;
        labelFrame.origin.y += (self.window.frame.size.height - kOverlaySize) / 2.0f;
    }
    return labelFrame;
}
@end
