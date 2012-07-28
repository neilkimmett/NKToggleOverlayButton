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
 * NKViewController.m
 *
 */


#import "NKViewController.h"
#import "NKToggleOverlayButton.h"

@interface NKViewController ()

@end

@implementation NKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 30)];
    titleLabel.text = @"NKToggleOverlayButton";
    titleLabel.textColor = [UIColor colorWithRed:0.6 green:0.0 blue:0.0 alpha:1.0];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleLabel.shadowColor = [UIColor lightGrayColor];
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 280, 80)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor = [UIColor darkGrayColor];
    descriptionLabel.text = @"A two state button that displays a translucent overlay when it's state is changed. The overlay contains a customisable line of text and an image.";
    [self.view addSubview:descriptionLabel];
    [descriptionLabel release];

    NKToggleOverlayButton *button = [[NKToggleOverlayButton alloc] init];
    button.frame = CGRectMake(0, 250, 320, 100);
    [button setOnImage:[UIImage imageNamed:@"on"] forState:UIControlStateNormal];
    [button setOnImage:[UIImage imageNamed:@"on-press"] forState:UIControlStateHighlighted];
    [button setOffImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
    [button setOffImage:[UIImage imageNamed:@"off-press"] forState:UIControlStateHighlighted];    
    button.overlayOnText = @"Saved";
    button.overlayOffText = @"Removed";
    button.toggleOnBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Saved");
    };
    button.toggleOffBlock = ^(NKToggleOverlayButton *button) {
        NSLog(@"Removed");
    };
    
    [self.view addSubview:button];
    [button release];
}

	
@end
