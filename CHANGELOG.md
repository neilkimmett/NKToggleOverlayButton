## v2.1.0
- add `style` property for changing the appearance of the overlay
- refactor overlay view out into its own class `NKOverlayView`
- remove iOS6 support
- use `FXBLurView` for blurring

## v2.0.0
- updated for iOS7 (overlay is a translucent blur like `UIAlertView`)
- transitioned to ARC
- did unholy amounts of refactoring
- changed superclass to `UIControl` so target/action pattern can be used
- removed `delegate` which is now redundant thanks to target/action
- removed custom property `isOn`, use standard `selected` property now

## v1.0.0