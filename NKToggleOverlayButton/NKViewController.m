//
//  NKViewController.m
//  NKToggleOverlayButton
//

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
    descriptionLabel.text = @"A two state button that displays a translucent overlay when it's state is changed. The overlay contains customisable line of text and an image.";
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
