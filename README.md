![Mid-animation screenshot of button being toggled on](https://github.com/neilkimmett/NKToggleOverlayButton/blob/master/screenshot-on.png "Button toggled on") ![Mid-animation screenshot of button being toggled off](https://github.com/neilkimmett/NKToggleOverlayButton/blob/master/screenshot-off.png "Button toggled off")


## What is NKToggleOverlayButton?

NKToggleOverlayButton is a two state button that displays a translucent overlay when it's state is changed. The overlay contains a customisable line of text and an image.

You can attach actions to the button using the toggleOnBlock and toggleOffBlock blocks. As ever be wary of creating retain cycles: using self in
the block results in the block retaining a reference to self and creating a retain cycle. Instead create a weak reference to self (`__block typeof(self) weakSelf = self`) and use that in the block. I only mention this because I've been burned by it myself :)

The appearance of the button is changed using the 
setOnImage:forState: and setOffImage:forState: methods, which are analogous to 
the setImage:forState: method of UIButton. All in all I hope its all pretty
self explanatory.

Pull requests encouraged :)


## Installation

* Drag the `NKToggleOverlayButton` folder into your project
* `#import "NKToggleOverlayButton.h"`

## How to use

N.B. Not currently ARC-compatible, so if you're using ARC add the `-fno-objc-arc` compiler flag to all the files from this project 

``` objective-c

NKToggleOverlayButton *button = [[NKToggleOverlayButton alloc] init];
button.frame = CGRectMake(100, 100, 200, 100);
[button setOnImage:[UIImage imageNamed:@"button-on"] forState:UIControlStateNormal];
[button setOnImage:[UIImage imageNamed:@"button-on-press"] forState:UIControlStateHighlighted];
[button setOffImage:[UIImage imageNamed:@"button-off"] forState:UIControlStateNormal];
[button setOffImage:[UIImage imageNamed:@"button-off-press"] forState:UIControlStateHighlighted];
button.overlayOnImage = [UIImage imageNamed:@"tick"];
button.overlayOffImage = [UIImage imageNamed:@"cross"];
button.toggleOnBlock = ^(NKToggleOverlayButton *button) {
        // Code to execute when button is toggled on
};
button.toggleOffBlock = ^(NKToggleOverlayButton *button) {
        // Code to execute when button is toggled off
};
```

## Contact

Find me on Twitter [@neilkimmett](http://www.twitter.com/neilkimmett), or drop me an email at neil dot kimmett at gmail.com

## License

Copyright (c) 2012 Neil Kimmett

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.