import UIKit

var menuItems = [String]()
var tags = [Tag]()

class MenuViewController: UITableViewController {
    let slideOutAnimationEnabled: Bool = true
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "MENU"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuItems = [
            "Today",
            "Next 7 Days",
            "Tags"
        ]
        
        tags = [
            Tag(name: "Home", color: UIColor.greenColor()),
            Tag(name: "School", color: UIColor.grayColor()),
            Tag(name: "Work", color: UIColor.redColor())
        ]
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.blackColor()
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: NSStringFromClass(MenuCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuCell), forIndexPath: indexPath) as MenuCell
        cell.configure(menuItems[indexPath.row])
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var controller: UIViewController
        switch(indexPath.row) {
        case 0:
            controller = ListViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        case 1:
            controller = ListViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        case 2:
            controller = TagViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        default:
            break
        }

//        SlideNavigationController.sharedInstance()(popToRootAndSwitchToViewController: controller, withSlideOutAnimation:self.slideOutAnimationEnabled, andCompletion:nil) // TODO
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return menuCellHeight
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
