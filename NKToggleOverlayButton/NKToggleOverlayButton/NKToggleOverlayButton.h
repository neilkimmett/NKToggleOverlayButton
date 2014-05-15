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
 * NKToggleOverlayButton.h
 *
 */

#import "NKOverlayView.h"

#if NS_BLOCKS_AVAILABLE

@class NKToggleOverlayButton;

typedef void (^NKToggleActionBlock)(NKToggleOverlayButton *button);

#import <UIKit/UIKit.h>

/**
 NKToggleOverlayButton is a two state button that displays a translucent overlay when it's state is changed.

 Behaviour can be attached to the button by assigning action blocks to the toggleOnBlock and toggleOffBlock properties. Alternatively you can use addTarget:action:forControlEvents to add a target/action pair for the control event UIControlEventValueChanged (for when the button state is toggled) or UIControlEventTouchUpInside (for when the button is tapped)
 */
@interface NKToggleOverlayButton : UIControl

/**
 Programmatically toggles the button's on/off state
 @param animated Toggles whether to show the animated overlay
 */
- (void)toggleSelectedAnimated:(BOOL)animated;

/**
 Sets the the button's on/off state. Use -isSelected (declared in superclass UIControl) to query button's current state. Use -setSelected: (declared in superclass UIControl) to set the button's on/off state without triggering toggle[On|Off]Block to be executed.
 @param selected If true toggles the button on, if false toggles the button off
 @param animated Toggles whether to show the animated overlay
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

/**
 Assign an image to be used for the given state when the button is on
 @param image The image to be used
 @param state The control state to assign the given image for
 */
- (void)setOnImage:(UIImage *)image forState:(UIControlState)state;

/**
 Assign an image to be used for the given state when the button is off
 @param image The image to be used
 @param state The control state to assign the given image for
 */
- (void)setOffImage:(UIImage *)image forState:(UIControlState)state;

/// A label that occupies the whole bounds of the button
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/// The style of the overlay, light or dark
@property (nonatomic, assign) NKOverlayViewStyle style;

/// Whether to display the animated overlay or not
@property (nonatomic, assign) BOOL showOverlay;

/// Text that is displayed in the animated overlay when the button is toggled on
@property (nonatomic, copy) NSString *overlayOnText;

/// Text that is displayed in the animated overlay when the button is toggled off
@property (nonatomic, copy) NSString *overlayOffText;

/// Image that is displayed in the animated overlay when the button is toggled on
@property (nonatomic, strong) UIImage *overlayOnImage;

/// Image that is displayed in the animated overlay when the button is toggled off
@property (nonatomic, strong) UIImage *overlayOffImage;

/// Block that is executed when the button is toggled on
@property (nonatomic, copy) NKToggleActionBlock toggleOnBlock;

/// Block that is executed when the button is toggled off
@property (nonatomic, copy) NKToggleActionBlock toggleOffBlock;

@end

#endif