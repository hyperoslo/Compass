import UIKit
import Compass

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var navigationController: UINavigationController?
  lazy var mainController: ViewController = {
    let viewController = ViewController()
    viewController.title = "Main Controller"
    viewController.view.backgroundColor = .whiteColor()

    return viewController
    }()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    navigationController = UINavigationController(rootViewController: mainController)
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    Compass.scheme = "compass"
    Compass.routes = ["profile:{username}", "login:{username}", "logout"]
    
    return true
  }

  func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
    return Compass.parse(url) { route, arguments in
      if route == "profile:{username}" {
        let profileController = UIViewController()
        profileController.view.backgroundColor = UIColor.whiteColor()
        profileController.title = arguments["username"]
        self.navigationController?.pushViewController(profileController, animated: true)
      } else if route == "login:{username}" {
        let loginController = LoginController()
        loginController.title = arguments["username"]
        let username = arguments["username"]
        loginController.titleLabel.text = "\(loginController.titleLabel.text!) \(username!)"
        loginController.titleLabel.sizeToFit()
        self.navigationController?.pushViewController(loginController, animated: true)
      } else if route == "logout" {
        self.navigationController?.popToRootViewControllerAnimated(true)
      }
    }
  }
}
