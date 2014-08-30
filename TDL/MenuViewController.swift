import UIKit

class MenuViewController: UITableViewController {
    let slideOutAnimationEnabled: Bool = true
    
    convenience override init() {
        self.init(style: .Plain)
        title = "Dlaczego"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "WTF"

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.whiteColor()
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: NSStringFromClass(MenuCell))
        tableView.registerClass(MenuLogoCell.self, forCellReuseIdentifier: NSStringFromClass(MenuLogoCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count + 1
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuLogoCell), forIndexPath: indexPath) as MenuLogoCell
            return cell as MenuLogoCell
        }
        
        var all: Int = 0
        for i in 0...sectionItems.count-1 {
            if sectionItems[i].count > 0 {
                for j in 0...sectionItems[i].count-1 {
                    all++
                }
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuCell), forIndexPath: indexPath) as MenuCell
        cell.configure(menuItems[indexPath.row-1], count: (indexPath.row == 1 ? sectionItems[0].count : (indexPath.row == 2 ? all : nil)))
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var controller: UIViewController?
        switch(indexPath.row) {
        case 1:
            controller = TodayTaskViewController()
            break
        case 2:
            controller = TaskViewController()
            break
        case 3:
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
    
    override func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        if indexPath.row == 0 {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.row == 0 {
            return menuLogoCellHeight
        }
        
        return menuCellHeight
    }
}
