import UIKit

class MenuViewController: UITableViewController, SlideNavigationControllerDelegate {
    let slideOutAnimationEnabled: Bool = true
    
    convenience override init() {
        self.init(style: .Plain)
        title = "Hello"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.scrollEnabled = false

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
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
        cell.configure(menuItems[indexPath.row-1])
        cell.selected = true
        
        // #Description
        let view = UIView(frame: cell.bounds)
        view.layer.borderColor = UIColor.whiteColor().CGColor
        
        let separatorLine = UIView(frame: CGRect(x: 0, y: menuCellHeight, width: 320, height: 0.5)) // #Change
        separatorLine.backgroundColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        view.addSubview(separatorLine)
        
        cell.selectedBackgroundView = view
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView!, shouldHighlightRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {

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
            if interfaceOrientation.isLandscape {
                return menuLogoCellHeightLandscape
            }

            return menuLogoCellHeightPortrait
        }
        
        return menuCellHeight
    }
    
    override func viewDidLayoutSubviews() {
        self.updateCount()
    }
    
    func updateCount() {
        // Update count in menu cell
        var indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        var cell: MenuCell? = tableView.cellForRowAtIndexPath(indexPath) as MenuCell?
        if cell == nil {
            println("Menu cell is nil?")
            return
        }
        
        cell!.countTextLabel.text = String(sectionItems[0].count)
        
        var all: Int = 0
        for i in 0...sectionItems.count-1 {
            if sectionItems[i].count > 0 {
                for j in 0...sectionItems[i].count-1 {
                    all++
                }
            }
        }
        
        indexPath = NSIndexPath(forRow: 2, inSection: 0)
        cell = tableView.cellForRowAtIndexPath(indexPath) as MenuCell?
        cell!.countTextLabel.text = String(all)
    }
}
