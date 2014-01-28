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
 * NKViewController.m
 *
 */

#import <QuartzCore/QuartzCore.h>
#import "NKViewController.h"
#import "NKToggleOverlayButton.h"

@interface NKViewController ()

@end

@implementation NKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIColor *redColor = [UIColor colorWithRed:0.7f green:0.0f blue:0.0f alpha:1.0f];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 300, 30)];
    titleLabel.text = @"NKToggleOverlayButton";
    titleLabel.textColor = redColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame), 280, 80)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.text = @"A two state button that displays a translucent overlay when it's state is changed. The overlay contains a customisable line of text and an image.";
    [self.view addSubview:descriptionLabel];
    
    UILabel *button1Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(descriptionLabel.frame), 280, 30)];
    button1Label.numberOfLines = 0;
    button1Label.font = [UIFont systemFontOfSize:12];
    button1Label.textColor = [UIColor darkGrayColor];
    button1Label.text = @"I'm a button who uses images.";
    [self.view addSubview:button1Label];

    UIImage *onImage = [UIImage imageNamed:@"on"];
    NKToggleOverlayButton *button1 = [[NKToggleOverlayButton alloc] init];
    button1.frame = CGRectMake(20, CGRectGetMaxY(button1Label.frame) + 10, onImage.size.width, onImage.size.height);
    button1.contentMode = UIViewContentModeScaleAspectFit;
    [button1 setOnImage:onImage forState:UIControlStateNormal];
    [button1 setOnImage:[UIImage imageNamed:@"on-press"] forState:UIControlStateHighlighted];
    [button1 setOffImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [button1 setOffImage:[UIImage imageNamed:@"off-press"] forState:UIControlStateHighlighted];    
    button1.overlayOnText = @"Saved";
    button1.overlayOffText = @"Removed";
    button1.toggleOnBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Saved");
    };
    button1.toggleOffBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Removed");
    };
    [button1 addTarget:self action:@selector(didToggleButton1:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:button1];
    
    UILabel *button2Label = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame) + 20, 280, 40)];
    button2Label.numberOfLines = 0;
    button2Label.font = [UIFont systemFontOfSize:12];
    button2Label.textColor = [UIColor darkGrayColor];
    button2Label.text = @"I'm a button who uses titleLabel and backgroundColor to draw themselves.";
    [self.view addSubview:button2Label];
    
    NKToggleOverlayButton *button2 = [[NKToggleOverlayButton alloc] init];
    button2.frame = CGRectMake(20, CGRectGetMaxY(button2Label.frame) + 10, 100, 44);
    
    button2.backgroundColor = [UIColor whiteColor];
    button2.layer.borderColor = redColor.CGColor;
    button2.layer.borderWidth = 1.0f;
    button2.layer.cornerRadius = 8.0f;
    button2.titleLabel.text = @"Tap me";
    button2.titleLabel.textColor = [UIColor blackColor];
    button2.overlayOnText = @"Added";
    button2.overlayOffText = @"Deleted";
    button2.toggleOnBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Added");
        button.backgroundColor = redColor;
        button.titleLabel.textColor = [UIColor whiteColor];
    };
    button2.toggleOffBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Deleted");
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.textColor = [UIColor blackColor];
    };
    [button2 addTarget:self action:@selector(didToggleButton2:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:button2];
}

#pragma mark - Target/action
- (void)didToggleButton1:(NKToggleOverlayButton *)button
{
    NSLog(@"Button 1 toggled %@", button.selected ? @"on" : @"off");
}

- (void)didToggleButton2:(NKToggleOverlayButton *)button
{
    NSLog(@"Button 2 toggled %@", button.selected ? @"on" : @"off");
}

@end
