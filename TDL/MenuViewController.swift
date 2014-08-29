import UIKit

class MenuViewController: UITableViewController {
    let slideOutAnimationEnabled: Bool = true
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "MENU"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.lightGrayColor()
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: NSStringFromClass(MenuCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuCell), forIndexPath: indexPath) as MenuCell
        cell.configure(menuItems[indexPath.row])
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var controller: UIViewController?
        switch(indexPath.row) {
        case 0:
            controller = TodayTaskViewController()
            break
        case 1:
            controller = TaskViewController()
            break
        case 2:
            controller = TagViewController()
            break
        default:
            break
        }
        
        if controller != nil {
            var slideNavigation = SlideNavigationController().sharedInstance()
            slideNavigation._delegate = controller as? SlideNavigationControllerDelegate
            slideNavigation.popToRootAndSwitchToViewController(controller!, slideOutAnimation: true, completion: { (Bool) -> Void in })
        } else {
            println("Something went wrong and controller has not been initiated")
        }
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return menuCellHeight
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
