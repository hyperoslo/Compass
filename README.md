# Compass

[![CI Status](http://img.shields.io/travis/hyperoslo/Compass.svg?style=flat)](https://travis-ci.org/hyperoslo/Compass)
[![Version](https://img.shields.io/cocoapods/v/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![License](https://img.shields.io/cocoapods/l/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![Platform](https://img.shields.io/cocoapods/p/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)

Compass helps you setup a central navigation system for your application.
This has many benefits, one of them being that controllers can now be
decoupled, meaning that the list that presents the detail no longer knows 
about what its presenting. Controllers become agnostic and view stay 
stupid. The user experience stays the same but the logic and separation of
concerns become clearer. The outcome is that your application will become 
more modular by default. Anything could potentially be displayed from 
anywhere but do tread safe, with great power comes great responsibility.

## Setup

1. First you need to register a URL scheme for your application
2. Now you need to configure Compass to use that URL scheme, a good place
to do this is in your `AppDelegate`
```swift
func application(application: UIApplication, 
  didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Compass.scheme = "compass"
    return true
}
```
3. Configure your application routes
```swift
func application(application: UIApplication, 
  didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Compass.scheme = "compass"
    Compass.routes = ["profile:{username}", "login:{username}", "logout"]
    return true
}
```
4. Setup your application to response to the URLs, this can be done in the `AppDelegate` but its up to you to find a more suitable place for it depending on the size of your implementation.
```swift
func application(app: UIApplication, 
  openURL url: NSURL, 
  options: [String : AnyObject]) -> Bool {
    return Compass.parse(url) { route, arguments in
      switch route {
        case "profile:{username}":
          let profileController = profileController(title: arguments["{username}"])
          self.navigationController?.pushViewController(profileController, 
            animated: true)
        case "login:{username}":
          let loginController = LoginController(title: arguments["{username}"])
          self.navigationController?.pushViewController(loginController, 
            animated: true)
        case "logout":
          logout()
        default: break
      }
    }
}
```

## Installation

**Compass** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Compass'
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## License

**Compass** is available under the MIT license. See the LICENSE file for more info.
