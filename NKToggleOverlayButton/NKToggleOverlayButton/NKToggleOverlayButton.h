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
 * NKToggleOverlayButton.h
 *
 */

#if NS_BLOCKS_AVAILABLE

@protocol NKToggleOverlayButtonDelegate;

@class NKToggleOverlayButton;

typedef void (^NKToggleActionBlock)(NKToggleOverlayButton *button);

#import <UIKit/UIKit.h>

#define kNotifyInterestUpdated @"ListingInterestDidUpdate"

@interface NKToggleOverlayButton : UIView

// Images used to set the on/off images for different control states,
// analogous to the setImage:forState: method of UIButton
- (void)setOnImage:(UIImage *)image forState:(UIControlState)state;
- (void)setOffImage:(UIImage *)image forState:(UIControlState)state;

// Title label
@property (nonatomic, retain) UILabel *titleLabel;

// Used to turn the overlay animation on or off (default on)
@property (nonatomic, assign) BOOL showOverlay;

// Used to determine the on/off state of the button (default off)
@property (nonatomic, assign) BOOL isOn;

// Text that is displayed in the overlay when button is toggled on/off
@property (nonatomic, copy) NSString *overlayOnText;
@property (nonatomic, copy) NSString *overlayOffText;

// Image displayed in the overlay when button is toggled on/off
@property (nonatomic, retain) UIImage *overlayOnImage;
@property (nonatomic, retain) UIImage *overlayOffImage;

// Blocks that are executed when the button is toggled on/off
//
// Remember to be careful not to create a retain cycle by capturing
// self strongly in these blocks; instead use a weak __block reference
// to self
@property (nonatomic, copy) NKToggleActionBlock toggleOnBlock;
@property (nonatomic, copy) NKToggleActionBlock toggleOffBlock;

// Delegate for if you want to kick it old school
@property (nonatomic, assign) id<NKToggleOverlayButtonDelegate> delegate;

@end


@protocol NKToggleOverlayButtonDelegate <NSObject>
@optional
- (void)toggleButtonDidToggle:(NKToggleOverlayButton *)button;
@end

#endif