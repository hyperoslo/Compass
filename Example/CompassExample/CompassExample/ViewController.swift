import UIKit
import Compass

class ViewController: UIViewController {

  lazy var scrollView: UIScrollView = UIScrollView()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Compass\nApp based navigation made easy🏁"
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)!
    label.textColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1)
    label.textAlignment = .Center
    label.numberOfLines = 0
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 60
    label.sizeToFit()

    return label
    }()

  lazy var profileButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "profileButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Show profile", forState: .Normal)

    return button
    }()

  lazy var loginButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "loginButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Show login", forState: .Normal)

    return button
    }()

  lazy var containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.grayColor()

    return view
    }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.whiteColor()

    navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .Plain, target: nil, action: nil)

    view.addSubview(scrollView)
    for subview in [titleLabel, profileButton, loginButton] { scrollView.addSubview(subview) }

    for button in [profileButton, loginButton] {
      button.setTitleColor(UIColor.grayColor(), forState: .Normal)
      button.layer.borderColor = UIColor.grayColor().CGColor
      button.layer.borderWidth = 1.5
      button.layer.cornerRadius = 7.5
    }

    guard let navigationController = navigationController else { return }

    navigationController.navigationBar.addSubview(containerView)
    containerView.frame = CGRect(x: 0,
      y: navigationController.navigationBar.frame.maxY - UIApplication.sharedApplication().statusBarFrame.height,
      width: UIScreen.mainScreen().bounds.width, height: 75)
  }

  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    title = "Compass".uppercaseString
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    setupFrames()
  }

  // MARK: Action methods

  func profileButtonDidPress(button: UIButton) {
    Compass.navigate("profile:jgorset")
  }

  func loginButtonDidPress(button: UIButton) {
    Compass.navigate("login:timkurvers")
  }

  // MARK - Configuration

  func setupFrames() {
    guard let navigationHeight = navigationController?.navigationBar.frame.height else { return }
    let totalSize = UIScreen.mainScreen().bounds
    let originY = navigationHeight + UIApplication.sharedApplication().statusBarFrame.height

    scrollView.frame = CGRect(x: 0, y: originY, width: totalSize.width, height: totalSize.height - originY)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: totalSize.height / 2 - 200)
    profileButton.frame = CGRect(x: 50, y: titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
    loginButton.frame = CGRect(x: 50, y: profileButton.frame.maxY + 15, width: totalSize.width - 100, height: 50)
  }
}

