![Animation of button being toggled on/off](https://github.com/neilkimmett/NKToggleOverlayButton/raw/master/animation.gif "Excuse the poor quality gif")

## What is NKToggleOverlayButton?

NKToggleOverlayButton is a two state button that displays a translucent overlay when it's state is changed. The overlay contains a customisable line of text and an image.

Behaviour can be attached to the button by assigning action blocks to the `toggleOnBlock` and `toggleOffBlock` properties. Alternatively you can use `addTarget:action:forControlEvents` to add a target/action pair for the control event `UIControlEventValueChanged` (for when the button state is toggled) or `UIControlEventTouchUpInside` (for when the button is tapped).

The appearance of the button is changed using the 
`setOnImage:forState:` and `setOffImage:forState:` methods, which are analogous to 
the `setImage:forState:` method of UIButton, or by using the `titleLabel` property.

The overlay can be either dark (default) or light. You can select a style thusly
``` objective-c
button.style = NKOverlayViewStyle[Dark|Light]
```

Hopefully everything is self-explanatory, if you need a hand open an issue or contact me (details found below).


## Installation

#### Using [CocoaPods](http://cocoapods.org/) (preferred method)
* Add `pod 'NKToggleOverlayButton', '~> 2.1'` to your `Podfile`

* Run
``` bash
$ pod install
```
to add the required files to your workspace.

## How to use

Example usage can be found in the demo project. If you're using CocoaPods 0.29 (or more recent) you can `pod try NKToggleOverlayButton` to check out the project temporarily and have a play.


``` objective-c

NKToggleOverlayButton *button = [[NKToggleOverlayButton alloc] init];
button.frame = CGRectMake(100, 100, 200, 100);

[button setOnImage:[UIImage imageNamed:@"button-on"] forState:UIControlStateNormal];
[button setOnImage:[UIImage imageNamed:@"button-on-press"] forState:UIControlStateHighlighted];
[button setOffImage:[UIImage imageNamed:@"button-off"] forState:UIControlStateNormal];
[button setOffImage:[UIImage imageNamed:@"button-off-press"] forState:UIControlStateHighlighted];

button.titleLabel.text = @"I'm a button!"

button.overlayOnImage = [UIImage imageNamed:@"tick"];
button.overlayOffImage = [UIImage imageNamed:@"cross"];

button.toggleOnBlock = ^(NKToggleOverlayButton *button) {
        // Code to execute when button is toggled on
};
button.toggleOffBlock = ^(NKToggleOverlayButton *button) {
        // Code to execute when button is toggled off
};
```

You can query the button's current state using 

``` objective-c
button.isSelected;
```

You can update the button's state (without displaying the overlay, or triggering `toggleOnBlock`, `toggleOffBlock` or any target/action pairs to be called) using
``` objective-c
button.selected = YES;
```
This is useful for setting an initial state of the button.

You can programmatically set the button's state and optionally trigger the animated overlay using
``` objective-c
[button setSelected:YES animated:YES];
```

Finally, you can toggle the button's state (switch between on and off), and optionally display the animated overlay using
``` objective-c
[button toggleSelectedAnimated:YES];
```

## ARC
`NKToggleOverlayButton` uses ARC. If your project does not use ARC add the `-fobjc-arc` compiler flag to all the files from this project (in your project settings click "Build Phases" at the top, then expand the "Compile Sources" section)

## Contact

Find me on Twitter [@neilkimmett](http://www.twitter.com/neilkimmett), or drop me an email at neil at kimmett.me

## License

Copyright (c) 2014 Neil Kimmett

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
