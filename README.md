# KVSpinnerView

`KVSpinnerView` is highly customizable progress HUD with a possibility to show messages or progress while some work is being done. `KVSpinnerView` has several animation types which was written using [CAAnimations](https://developer.apple.com/reference/quartzcore/caanimation).

![alt text](https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/Screenshots/standart-animation.gif)
![alt text](https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/Screenshots/infinite-animation.gif)

# Installation
### Cocoa Pods

Using [CocoaPods](https://cocoapods.org/) is highly recommended way you should use to add `KVSpinnerView` to your project

1. Add this line to your Podfile `pod 'KVSpinnerView', '~> 1.0'`

2. Close .xcodeproj -> Open terminal -> Open project directory -> run `pod install`

3. Import KVSpinnerView where needed (`import KVSpinnerView`)

### Manual installation

1. Download [latest code version](https://github.com/kuznetsovVladislav/KVSpinnerView/archive/master.zip)

2. Copy `KVSpinnerView` directory into your project

# Usage

You can use KVSpinnerView methods while some tasks are being done in background, some big tasks are loading, etc.
To show `KVSpinnerView` on your screen you should use its static methods.

```swift
KVSpinnerView.show()
self.doSomeTask().response { (object) in
	DispatchQueue.main.async {
		KVSpinnerView.dismiss()
	}
}
```

You also can add status message while KVSpinnerView is being shown. Background rectangle of KVSpinning view will automatically expand regarding to message width.

```swift
KVSpinnerView.show(saying: "Hello")
```

Use this method to remove SKSpinnerView after several seconds.

```swift
KVSpinnerView.dismiss(after: 5.0)
```

There is two ways to add KVSpinner view to your screen:

1. Use method `KVSpinnerView.show()` to add spinner to UIApplication's window. If you use this method then the spinner will be at screen untill you dismiss it.

2. Use method `KVSpinnerView.show(on: _)` to add the spinner to a view you choose, e.g.:

```swift
class ViewController: UIViewController {
	override func viewDidLoad() {
        super.viewDidLoad()
		KVSpinnerView.show(on: self.view)
    }
}
```

# Customize
Also `KVSpinnerView` is highly customizable. You can customize it by changing `KVSpinnerView.settings` parameters, such as:

- `animationStyle` - type of Spinner's animation. For now there are 2 variants: `standart`*(default)* and `infinite`

- `spinnerRadius`- radius of KVSpinnerView. Background rectangle changes its size regarldess to this parameter

- `linesWidth` - width of each animating line

- `linesCount` - total count of KVSpinnerView animating lines

- `backgroundOpacity` - opacity of background rectangle

- `tintColor` - color of each animating line

- `backgroundRectColor` - color of background rectangle

- `statusTextColor` - color of status message text

- `minimumDismissDelay` - KVSpinnerView will not be removed earlier than this parameter *(in seconds)*

- `animationDuration` - duration of one spin of animating lines

- `fadeInDuration` - duration of fade in of background rectangle

- `fadeOutDuration` - duration of fade out of background rectangle

# Screenshots
<img src="https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/Screenshots/purple.png" alt="Purple" width="220" height="380">
<img src="https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/Screenshots/gray.png" alt="Gray" width="220" height="380">
<img src="https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/Screenshots/black.png" alt="Purple" width="220" height="380">

# To do
- Add animation of progress handling (e.g. URLSession/Alamofire progress handling)
- Add several animation types
- Add success and error animations with status messages

# Licence

This code is distributed under the terms and conditions of the [MIT license](https://github.com/kuznetsovVladislav/KVSpinnerView/blob/master/LICENSE)

