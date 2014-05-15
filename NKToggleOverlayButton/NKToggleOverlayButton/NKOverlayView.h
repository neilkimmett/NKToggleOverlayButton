//
//  NKOverlayView.h
//  Food(ness)
//
//  Created by Neil Kimmett on 31/03/2014.
//  Copyright (c) 2014 Marks & Spencer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NKOverlayViewStyle) {
    NKOverlayViewStyleDark,
    NKOverlayViewStyleLight
};

@interface NKOverlayView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NKOverlayViewStyle style;

- (void)animateOnTransitionWithCompletion:(void (^)())completion;
- (void)animateOffTransitionWithCompletion:(void (^)())completion;

@end
