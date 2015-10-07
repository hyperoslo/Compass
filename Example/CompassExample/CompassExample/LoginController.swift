import UIKit
import Compass

class LoginController: UIViewController {

  lazy var scrollView: UIScrollView = UIScrollView()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Welcome: "
    label.font = UIFont(name: "HelveticaNeue-Medium", size: 20)!
    label.textColor = UIColor(red:0.86, green:0.86, blue:0.86, alpha:1)
    label.textAlignment = .Center
    label.numberOfLines = 0
    label.frame.size.width = UIScreen.mainScreen().bounds.width - 60
    label.sizeToFit()

    return label
    }()

  lazy var logoutButton: UIButton = { [unowned self] in
    let button = UIButton()
    button.addTarget(self, action: "logoutButtonDidPress:", forControlEvents: .TouchUpInside)
    button.setTitle("Logout", forState: .Normal)

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
    for subview in [titleLabel, logoutButton] { scrollView.addSubview(subview) }

    for button in [logoutButton] {
      button.setTitleColor(UIColor.grayColor(), forState: .Normal)
      button.layer.borderColor = UIColor.grayColor().CGColor
      button.layer.borderWidth = 1.5
      button.layer.cornerRadius = 7.5
    }
    setupFrames()
  }

  // MARK: Action methods

  func logoutButtonDidPress(button: UIButton) {
    Compass.navigate("logout")
  }

  // MARK - Configuration

  func setupFrames() {
    guard let navigationHeight = navigationController?.navigationBar.frame.height else { return }
    let totalSize = UIScreen.mainScreen().bounds
    let originY = navigationHeight + UIApplication.sharedApplication().statusBarFrame.height

    scrollView.frame = CGRect(x: 0, y: originY, width: totalSize.width, height: totalSize.height - originY)
    titleLabel.frame.origin = CGPoint(x: (totalSize.width - titleLabel.frame.width) / 2, y: totalSize.height / 2 - 200)
    logoutButton.frame = CGRect(x: 50, y: titleLabel.frame.maxY + 75, width: totalSize.width - 100, height: 50)
  }
}

