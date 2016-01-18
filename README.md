![Compass logo](https://raw.githubusercontent.com/hyperoslo/Compass/master/Images/logo_v1.png)

[![Version](https://img.shields.io/cocoapods/v/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![Platform](https://img.shields.io/cocoapods/p/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)

Compass helps you setup a central navigation system for your application.
This has many benefits, one of them being that controllers can now be
decoupled, meaning that the list that presents the detail no longer knows
about what its presenting. Controllers become agnostic and views stay
stupid. The user experience stays the same but the logic and separation of
concerns become clearer. The outcome is that your application will become
more modular by default. Anything could potentially be presented from
anywhere, but remember, with great power comes great responsibility.

## Setup

#### Step 1
First you need to register a URL scheme for your application
<img src="https://raw.githubusercontent.com/hyperoslo/Compass/master/Images/setup-url-scheme.png">

[![CI Status](http://img.shields.io/travis/hyperoslo/Compass.svg?style=flat)](https://travis-ci.org/hyperoslo/Compass)

#### Step 2
Now you need to configure Compass to use that URL scheme, a good place
to do this is in your `AppDelegate`
```swift
func application(application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Compass.scheme = "compass"
    return true
}
```
#### Step 3
Configure your application routes
```swift
func application(application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    Compass.scheme = "compass"
    Compass.routes = ["profile:{username}", "login:{username}", "logout"]
    return true
}
```
#### Step 4
Set up your application to respond to the URLs, this can be done in the `AppDelegate` but its up to you to find a more suitable place for it depending on the size of your implementation.
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

Setting it up this way would mean that
you could open any view from a push notification depending on the contents of the payload.
Preferably you would add your own global function that you use for internal navigation.

## Compass life hacks

##### Tip 1. Router
We also have some conventional tools for you that could be used to organize your
route handling code and avoid huge `switch` cases.

- Implement `Routable` protocol to keep your single route navigation code
in one place:
```swift
struct ProfileRoute: Routable {
  func resolve(arguments: [String: String], navigationController: UINavigationController?) {
    guard let username = arguments["username"] else { return }

    let profileController = profileController(title: username)
    navigationController?.pushViewController(profileController, animated: true)
  }
}
```

- Create a `Router` instance and register your routes:
```swift
let router = Router()
router.routes = [
  "profile:{username}" : ProfileRoute(),
  // "logout" : LogoutRoute()
]
```

- Parse URL with **Compass** and navigate to the route with a help of your
`Router` instance.
```swift
func application(app: UIApplication,
  openURL url: NSURL,
  options: [String : AnyObject]) -> Bool {
    return Compass.parse(url) { route, arguments in
      router.navigate(route, arguments: arguments,
        navigationController: navigationController)
    }
}
```

##### Tip 2. Navigation handler
You could have multiple handlers depending on if a user is logged in or not.
```swift
struct NavigationHandler {
  static func routePreLogin(route: String, arguments: [String: String],
    navigationController: UINavigationController) {
      switch route {
      case "forgotpassword:{username}":
        let forgotPasswordController = ForgotPasswordController(title: arguments["{username}"])
        navigationController?.pushViewController(loginController,
          animated: true)
      default: break
      }
  }

  static func routePostLogin(route: String, arguments: [String: String],
    navigationController: UINavigationController) {
      switch route {
      case "profile:{username}":
        let profileController = ProfileController(title: arguments["{username}"])
        navigationController?.pushViewController(profileController,
          animated: true)
      case "logout":
        AppDelegate.logout()
      default: break
      }
  }
}
```

If you use `Router`-based approach you could set up 2 routers depending on the
auth state.
```swift
let routerPreLogin = Router()
routerPreLogin.routes = [
  "profile:{username}" : ProfileRoute()
]

let routerPostLogin = Router()
routerPostLogin.routes = [
  "login:{username}" : LoginRoute()
]

let router = isLoggedIn ? routerPostLogin : routerPreLogin
router.navigate(route, arguments: arguments, navigationController: navigationController)
```

##### Tip 3. Global function
Add your own global function to easily navigate internally
``` swift
import Compass

public func navigate(urn: String) {
  let stringURL = "\(Compass.scheme)\(urn)"
  guard let appDelegate = UIApplication.sharedApplication().delegate as? ApplicationDelegate,
    url = NSURL(string: stringURL) else { return }

  appDelegate.handleURL(url)
}
```

## Installation

**Compass** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Compass'
```

**Compass** is also available through [Carthage](https://github.com/Carthage/Carthage).
To install just write into your Cartfile:

```ruby
github "hyperoslo/Compass"
```

## Author

Hyper Interaktiv AS, ios@hyper.no

## Credits

The idea behind Compass came from [John Sundell](https://github.com/JohnSundell)'s tech talk "*Components & View Models in the Cloud - how Spotify builds native, dynamic UIs*"

## License

**Compass** is available under the MIT license. See the LICENSE file for more info.
