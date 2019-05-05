![Alt Text](/Docs/images/header.png)


# OSCoachmarkView [Under Development]
[![Maintainability](https://api.codeclimate.com/v1/badges/d08c7dbce940087be5bd/maintainability)](https://codeclimate.com/github/AamirAnwar/OSListCoachmark/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/d08c7dbce940087be5bd/test_coverage)](https://codeclimate.com/github/AamirAnwar/OSListCoachmark/test_coverage)
  [![Build Status](https://travis-ci.com/AamirAnwar/OSListCoachmark.svg?branch=master)](https://travis-ci.com/AamirAnwar/OSListCoachmark)
  [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)  [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md)   

A lightweight framework for displaying coachmarks in iOS apps. Built in pure Swift 👨‍💻

![Alt Text](/Docs/images/illustrations.png)

## Showcase 

### Standard List Coachmark

A compact coachmark which is generally used in list views. Here's a demo of what this looks like,


![Alt Text](/Docs/images/standard_coachmark.gif)


### Appstore coachmark

A coachmark similar to the one used on the appstore product page.  


![Alt Text](/Docs/images/appstore_coachmark.gif)  

## Installation

### Cocoapods

For [CocoaPods](https://cocoapods.org), add this to your podfile

```ruby
  pod 'OSCoachmarkView', '~> 0.1'
```

### Carthage 
For [Carthage](https://github.com/Carthage/Carthage), add the following to your Cartfile

```ogdl
github "AamirAnwar/OSListCoachmark" ~> 0.1
```


## Usage

You can use any of the preset coachmarks using OSListCoachmarkGenerator or create any custom view in the same fashion. Here is how you would embed your custom view inside the coachmark. 

```swift
let view = CustomCoachmarkView()
let coachmarkView = OSCoachmarkView()
coachmarkView.attachedView = view
```

Sizing of the above custom coachmark will be based on autolayout subject to min/max constraints.
To position the coachmark relative to the view, you can write your own logic to show/hide the coachmark or you can use OSCoachmarkPresenter to do this. Here's an example of what this might look like - 

```swift
let coachmarkPresenter = OSCoachmarkPresenter()
coachmarkPresenter.view = coachmarkView
coachmarkPresenter.attachToView(self.view, anchor: .bottom)
```

OSCoachmarkPresenter objects can attach a coachmark to a given view with two modes - top and bottom. All animation and presentation logic is taken care of with you only having to call show() and hide() based on any logic you choose.

```swift
// Show
self.coachmarkPresenter.show()

//Hide
self.coachmarkPresenter.hide()
```


Checkout the example Xcode Project in the Example folder which has a demo with all three classes in action 🚀

### Additional Features 

- Added Blur support in OSListCoachmarkView 
- Optional loader in OSListCoachmarkView 

## Documentation
You can find the reference docs under `OSCoachmarkView/docs/index.html`

## Requirements

- iOS 11.0+
- Xcode 9
- Swift 4

## Contributing

All help is welcome. Open an issue or even better submit a pull request 😀

## Author

Aamir Anwar [@aamiranwarr](https://twitter.com/aamiranwarr)
Feel free to reach out to me on twitter!

## License

OSListCoachmark is released under the MIT license. See [LICENSE](https://github.com/AamirAnwar/OSListCoachmark/blob/master/LICENSE) for more details.

## Todo

* [X] Abstract out presenter logic
* [X] Add animation options to both top and bottom modes
* [X] Add blur support
* [X] Create example coachmarks using the Factory Pattern
* [X] Add Cocoapod/Carthage support
* [X] Polish README
* [X] Add Travis Support
* [X] Generate documentation
