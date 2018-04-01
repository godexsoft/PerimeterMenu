# PerimeterMenu

[![CI Status](http://img.shields.io/travis/godexsoft/PerimeterMenu.svg?style=flat)](https://travis-ci.org/godexsoft/PerimeterMenu)
[![Version](https://img.shields.io/cocoapods/v/PerimeterMenu.svg?style=flat)](http://cocoapods.org/pods/PerimeterMenu)
[![License](https://img.shields.io/cocoapods/l/PerimeterMenu.svg?style=flat)](http://cocoapods.org/pods/PerimeterMenu)
[![Platform](https://img.shields.io/cocoapods/p/PerimeterMenu.svg?style=flat)](http://cocoapods.org/pods/PerimeterMenu)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Example in a gif

![Example gif here](https://media.giphy.com/media/ywlOFzFBnkgrPUL1jZ/giphy.gif)

## Requirements

iOS 10+

## Installation

PerimeterMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'PerimeterMenu'
```

## Configuring
This section describes how to configure your PerimeterMenu for your needs.

### Delegate / Datasource

Implement __PerimeterMenuDelegate__ for datasource.

_Note:_ Datasource is __mandatory__.

```swift
func perimeterMenu(_ menu: PerimeterMenu,
  configurationFor itemPosition: Int,
  withButton button: UIButton)
```

Implement __PerimeterMenuDelegate__ for delegate methods.

_Note:_ All delegate methods are __optional__ and self explanatory.

```swift
func perimeterMenu(_ menu: PerimeterMenu,
  didSelectItem button: UIButton,
  at position: Int)

func perimeterMenu(_ menu: PerimeterMenu,
  didStartHoveringOver button: UIButton,
  at position: Int)

func perimeterMenu(_ menu: PerimeterMenu,
  didEndHoveringOver button: UIButton,
  at position: Int)

func perimeterMenuWillCollapse(_ menu: PerimeterMenu)

func perimeterMenuWillExpand(_ menu: PerimeterMenu)

func perimeterMenuDidCollapse(_ menu: PerimeterMenu)

func perimeterMenuDidExpand(_ menu: PerimeterMenu)
```

__Note:__ Please make sure you specify/connect your delegate and datasource either thru code or thru the storyboard.

### Callbacks

There are two callbacks available on the PerimeterMenu instance. Both are __optional__.

- __onButtonTap__ is called when the PerimeterMenu main button is tapped.

- __onButtonLongPress__ is called when the PerimeterMenu main button is long pressed.

Both callbacks are expected to __return a boolean__.
Return __true__ if the default action (expanding the menu) should still fire.
Return __false__ if you want to completely override the default action with your own provided as the body of the closure/block.

__IMPORTANT:__ Never return __true__ if you are planning to __performSegue__ to another controller. If you do so the menu will expand and overlap the newly presented controller.

## Authors

- Alex Kremer, godexsoft at gmail dot com
- Valera Chevtaev, myltik at gmail dot com

## License

PerimeterMenu is available under the MIT license. See the LICENSE file for more info.
