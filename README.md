![Alt Text](/Docs/images/header.png)


# OSCoachmarkView [Under Development]
  [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)  [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md)   

A lightweight framework for displaying coachmarks in iOS apps. 
Built with zero non-native dependencies.

![Alt Text](/Docs/images/illustrations.png)

## Showcase 

### Standard List Coachmark

A compact coachmark which is generally used in list views. Here's a demo of what this looks like,


![Alt Text](/Docs/images/standard_coachmark.gif)


### Appstore coachmark

A coachmark similar to the one used on the appstore product page.  


![Alt Text](/Docs/images/appstore_coachmark.gif)  

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


# Contributing

All help is welcome. Open an issue or even better submit a pull request 😀

# Author

Aamir Anwar [@aamiranwarr](https://twitter.com/aamiranwarr)
Feel free to reach out to me out twitter!

## License

OSListCoachmark is released under the MIT license. See [LICENSE](https://github.com/AamirAnwar/OSListCoachmark/blob/master/LICENSE) for more details.

# TODO

* [X] Abstract out presenter logic
* [X] Add animation options to both top and bottom modes
* [X] Add blur support
* [X] Create example coachmarks using the Factory Pattern
* [ ] Add logic for expanding coachmark THEN showcasing the content view
* [ ] Add Cocoapod/Carthage support
* [ ] Polish README
* [ ] Add Travis Support
* [ ] Generate documentation
