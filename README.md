![Compass logo](https://raw.githubusercontent.com/hyperoslo/Compass/master/Images/logo_v1.png)

[![Version](https://img.shields.io/cocoapods/v/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![Platform](https://img.shields.io/cocoapods/p/Compass.svg?style=flat)](http://cocoadocs.org/docsets/Compass)
[![CI Status](http://img.shields.io/travis/hyperoslo/Compass.svg?style=flat)](https://travis-ci.org/hyperoslo/Compass)
![Swift](https://img.shields.io/badge/%20in-swift%203.0-orange.svg)

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
First you need to register a URL scheme for your application.

<img src="https://raw.githubusercontent.com/hyperoslo/Compass/master/Images/setup-url-scheme.png">

#### Step 2
Now you need to configure Compass to use that URL scheme, a good place
to do this is in your `AppDelegate`. Then configure all the routes you wish you support.

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  Navigator.scheme = "compass"
  Navigator.routes = ["profile:{username}", "login:{username}", "logout"]
  return true
}
```

#### Step 3

Register your location request handler


```swift
Navigator.handle = { [weak self] location in
  let arguments = location.arguments

  let rootController = self?.window.rootViewController as? UINavigationController

  switch location.path {
    case "profile:{username}":
      let profileController = ProfileController(title: arguments["username"])
      rootController?.pushViewController(profileController, animated: true)
    case "login:{username}":
      let loginController = LoginController(title: arguments["username"])
      rootController?.pushViewController(loginController, animated: true)
    case "logout":
      self?.clearLoginSession()
      self?.switchToLoginScreen()
    default: 
      break
  }
}
```

#### Step 4

Anywhere in your application, you can just use `Navigator` to navigate

```swift
@IBOutlet func logoutButtonTouched() {
  Navigator.navigate(urn: "logout")
}
```

#### Step 5
Optional. If you want to support deep linking,  set up your application to respond to the URLs. Setting it up this way would mean that
you could open any view from a push notification depending on the contents of the payload.

```swift
func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
  do {
    try Navigator.navigate(url: url)
  } catch {
    // Handle error
  }

  return true
}
```

## Compass life hacks

### Tip 1. Router
We also have some conventional tools for you that could be used to organize your
route handling code and avoid huge `switch` cases.

- Implement `Routable` protocol to keep your single route navigation code
in one place:
```swift
struct ProfileRoute: Routable {

  func navigate(to location: Location, from currentController: CurrentController) throws {
    guard let username = location.arguments["username"] else { return }

    let profileController = ProfileController(title: username)
    currentController.navigationController?.pushViewController(profileController, animated: true)
  }
}
```

- Create a `Router` instance and register your routes. Think of `Router` as a composite `Routable`
```swift
let router = Router()
router.routes = [
  "profile:{username}": ProfileRoute(),
  "logout": LogoutRoute()
]
```

- Parse URL with **Compass** and navigate to the route with a help of your
`Router` instance.
```swift
func application(_ app: UIApplication,
                 open url: URL,
                 options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
  
  return handle(url)
}

func handle(_ url: URL) -> Bool {
  guard let location = Navigator.parse(url) else {
    return false
  }

  router.navigate(to: location, from: navigationController)

  return true
}
```

### Tip 2. Multiple routers
You could set up multiple routers depending on app states. For example, you could have 2 routers for pre and post login.

```swift
let preLoginRouter = Router()
preLoginRouter.routes = [
  "profile:{username}" : ProfileRoute()
]

let postLoginRouter = Router()
postLoginRouter.routes = [
  "login:{username}" : LoginRoute()
]

let router = hasLoggedIn ? postLoginRouter : preLoginRouter
router.navigate(to: location, from: navigationController)
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
