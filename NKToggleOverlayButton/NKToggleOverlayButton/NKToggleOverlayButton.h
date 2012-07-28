//
//  NKToggleOverlayButton.h
//

#if NS_BLOCKS_AVAILABLE

@class NKToggleOverlayButton;

typedef void (^NKToggleActionBlock)(NKToggleOverlayButton *button);

#import <UIKit/UIKit.h>

#define kNotifyInterestUpdated @"ListingInterestDidUpdate"

@interface NKToggleOverlayButton : UIView

// Images used to set the on/off images for different control states,
// analogous to the setImage:forState: method of UIButton
- (void)setOnImage:(UIImage *)image forState:(UIControlState)state;
- (void)setOffImage:(UIImage *)image forState:(UIControlState)state;

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

@end

#endif