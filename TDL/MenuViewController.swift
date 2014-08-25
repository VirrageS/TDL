import UIKit


class MenuViewController: UITableViewController {
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "MENU"
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}