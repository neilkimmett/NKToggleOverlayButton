/*
 This file is part of NKToggleOverlayButton.
 
 Copyright (c) 2012, Neil Kimmett
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


#import <QuartzCore/QuartzCore.h>
#import "NKToggleOverlayButton.h"

@interface NKToggleOverlayButton()
{
    UIButton *_button;
    NSMutableDictionary *_onImagesForStates;
    NSMutableDictionary *_offImagesForStates;
}

- (void)animateOverlayView;

@end

@implementation NKToggleOverlayButton

@synthesize
isOn = _isOn,
showOverlay = _showOverlay,
overlayOnText = _overlayOnText,
overlayOffText = _overlayOffText,
overlayOnImage = _overlayOnImage,
overlayOffImage = _overlayOffImage,
toggleOnBlock = _toggleOnBlock,
toggleOffBlock = _toggleOffBlock;

- (void)dealloc 
{
    [_onImagesForStates release];
    [_offImagesForStates release];
    [_toggleOnBlock release];
    [_toggleOffBlock release];
    [_overlayOnImage release];
    [_overlayOffImage release];
    [_overlayOnText release];
    [_overlayOffText release];
    [_button release];
    [super dealloc];
}

- (id)init;
{
    self = [super init];
    if (self)
    {        
        // By default show the overlay animation
        _showOverlay = YES;
        
        // Add a gesture recognizer, so we behave like a button
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(toggle:)];
        tap.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tap];
        [tap release];
        
        // Instantiate dictionary used to store on/off images for different UIControlStates
        _onImagesForStates = [[NSMutableDictionary alloc] init];
        _offImagesForStates = [[NSMutableDictionary alloc] init];
        
        // Default images for overlay
        _overlayOnImage = [[UIImage imageNamed:@"tick"] retain];
        _overlayOffImage = [[UIImage imageNamed:@"cross"] retain];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_button)
    {
        _button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [self assignButtonImagesForStates];
        [self addSubview:_button];
    }
    _button.frame = self.bounds;
    _button.backgroundColor = self.backgroundColor;
}

#pragma mark -
#pragma mark Button image handling

- (void)setOnImage:(UIImage *)image forState:(UIControlState)state
{
    if (self.isOn)
    {
        [_button setImage:image forState:state];
    }
    [_onImagesForStates setObject:image forKey:[NSNumber numberWithInt:state]];
}

- (void)setOffImage:(UIImage *)image forState:(UIControlState)state;
{
    if (!self.isOn)
    {
        [_button setImage:image forState:state];
    }
    [_offImagesForStates setObject:image forKey:[NSNumber numberWithInt:state]];
}

- (void)assignButtonImagesForStates
{
    NSDictionary *states = self.isOn ? _onImagesForStates : _offImagesForStates;
    // Set the appropriate images for our button
    [states enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, UIImage *image, BOOL *stop)
     {
         UIControlState state = [key intValue];
         [_button setImage:image forState:state];
     }];
    
}
     
#pragma mark -
#pragma mark Toggling
     
- (void)toggle:(UITapGestureRecognizer *)recognizer
{
    // Flip the switch
    _isOn = !_isOn;
    
    [self assignButtonImagesForStates];
    
    NKToggleActionBlock actionBlock = self.isOn ? self.toggleOnBlock : self.toggleOffBlock;
    
    if (actionBlock)
        actionBlock(self);
    
    [self animateOverlayView];
}

#pragma mark -
#pragma mark Animation
- (void)animateOverlayView
{
    self.userInteractionEnabled = NO;
    
    CGFloat overlaySize = 100;
    CGRect overlayFrame = CGRectMake((self.window.bounds.size.width-overlaySize)/2.0,
                                     (self.window.bounds.size.height-overlaySize)/2.0, 
                                     overlaySize, overlaySize);
    
    UIView *overlayView = [[UIView alloc] initWithFrame:overlayFrame];
    overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    overlayView.layer.cornerRadius = 12.0;
    overlayView.alpha = 0.2;
    
    [self.window addSubview:overlayView];
    [overlayView release];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:overlayView.bounds];
    imageView.contentMode = UIViewContentModeCenter;
    
    [overlayView addSubview:imageView];
    [imageView release];
        
    
    CGRect labelFrame = CGRectMake(0, overlaySize-overlaySize/5.0, overlaySize, 15);    
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.alpha = 0.0;
    
    [overlayView addSubview:label];
    [label release];
    
    if (self.isOn)
    {
        overlayView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        label.text = self.overlayOnText;
        imageView.image = self.overlayOnImage;
        
        // Unholy nested animation block
        [UIView animateWithDuration:0.2 animations:^{
            overlayView.alpha = 1.0;
            overlayView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.05
                              animations:^{label.alpha = 1.0;}
                              completion:^(BOOL finished)
              {
                  [UIView animateWithDuration:0.1
                                        delay:0.2 
                                      options:UIViewAnimationOptionCurveLinear
                                   animations:^{label.alpha = 0.0;}
                                   completion:^(BOOL finished)
                   {
                       [UIView animateWithDuration:0.2 
                                             delay:0.0
                                           options:UIViewAnimationCurveEaseIn
                                        animations:^{
                                            overlayView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                            overlayView.alpha = 0.0;
                                        }
                                        completion:^(BOOL finished)
                        {
                            [overlayView removeFromSuperview];
                            self.userInteractionEnabled = YES;
                        }];
                   }];
              }];
         }];
    }
    else
    {
        overlayView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        
        label.text = self.overlayOffText;
        imageView.image = self.overlayOffImage;

        // Unholy nested animation block
        [UIView animateWithDuration:0.2 animations:^{
            overlayView.alpha = 1.0;
            overlayView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished)
         {
             [UIView animateWithDuration:0.05
                              animations:^{label.alpha = 1.0;}
                              completion:^(BOOL finished)
              {
                  [UIView animateWithDuration:0.1
                                        delay:0.2 
                                      options:UIViewAnimationOptionCurveLinear
                                   animations:^{label.alpha = 0.0;}
                                   completion:^(BOOL finished)
                   {
                       [UIView animateWithDuration:0.2 
                                             delay:0.0
                                           options:UIViewAnimationCurveEaseIn
                                        animations:^{
                                            overlayView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                            overlayView.alpha = 0.0;
                                        }
                                        completion:^(BOOL finished)
                        {
                            [overlayView removeFromSuperview];
                            self.userInteractionEnabled = YES;
                        }];
                   }];
              }];
         }];
    }
}

@end
