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

#import "NKToggleOverlayButton.h"
#import "MSArchIndependentRounding.h"
#import "NKOverlayView.h"

@interface NKToggleOverlayButton()
{
    UIButton *_button;
    NSMutableDictionary *_onImagesForStates;
    NSMutableDictionary *_offImagesForStates;
}

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
        _overlayOnImage = [UIImage imageNamed:@"thin-tick"];
        _overlayOffImage = [UIImage imageNamed:@"thin-cross"];
    
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
    }
    else {
        actionBlock = self.toggleOffBlock;
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

    NKOverlayView *overlayView = [[NKOverlayView alloc] init];
    [self.window addSubview:overlayView];
    
    if (self.isSelected) {
        overlayView.textLabel.text = self.overlayOnText;
        overlayView.imageView.image = [self.overlayOnImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [overlayView animateOnTransitionWithCompletion:^{
            self.userInteractionEnabled = YES;
        }];
    }
    else {
        overlayView.textLabel.text = self.overlayOffText;
        overlayView.imageView.image = [self.overlayOffImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [overlayView animateOffTransitionWithCompletion:^{
            self.userInteractionEnabled = YES;
        }];
    }
}

#pragma mark - Accessibility
- (UIAccessibilityTraits)accessibilityTraits
{
    if (self.isSelected) {
        return UIAccessibilityTraitButton | UIAccessibilityTraitSelected;
    }
    else {
        return UIAccessibilityTraitButton;
    }
}

@end
