## v2.0.0
- updated for iOS7 (overlay is a translucent blur like `UIAlertView`)
- transitioned to ARC
- did unholy amounts of refactoring
- changed superclass to `UIControl` so target/action pattern can be used
- removed `delegate` which is now redundant thanks to target/action
- removed custom property `isOn`, use standard `selected` property now

## v1.0.0