import UIKit

class MenuViewController: UITableViewController, SlideNavigationControllerDelegate {
    let slideOutAnimationEnabled: Bool = true
    
    convenience override init() {
        self.init(style: .Plain)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.scrollEnabled = false

        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: NSStringFromClass(MenuCell))
        tableView.registerClass(MenuLogoCell.self, forCellReuseIdentifier: NSStringFromClass(MenuLogoCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuLogoCell), forIndexPath: indexPath) as MenuLogoCell
            return cell as MenuLogoCell
        }
        
        var all: Int = allTasks.count
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuCell), forIndexPath: indexPath) as MenuCell
        cell.configure(menuItems[indexPath.row-1])
        cell.selected = true

        // View for separator line
        var view: UIView
        var separatorLineBottom: UIView
        var separatorLineTop: UIView
       
        view = UIView(frame: cell.bounds)
        view.backgroundColor = UIColor.clearColor()
        
        separatorLineBottom = UIView(frame: CGRectZero)
        separatorLineBottom.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        separatorLineTop = UIView(frame: CGRectZero)
        separatorLineTop.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        view.addSubview(separatorLineBottom)
        view.addSubview(separatorLineTop)
        
        separatorLineBottom.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: separatorLineBottom, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: separatorLineBottom, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -0.5))
        view.addConstraint(NSLayoutConstraint(item: separatorLineBottom, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: separatorLineBottom, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        separatorLineTop.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: separatorLineTop, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: separatorLineTop, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: separatorLineTop, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: separatorLineTop, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0.5))
        
        cell.selectedBackgroundView = view
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        case 4:
            controller = FilterViewController()
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Menu cell height for portrait and landscape
        if indexPath.row == 0 {
            if interfaceOrientation.isLandscape {
                return menuLogoCellHeightLandscape
            }

            return menuLogoCellHeightPortrait
        }
        
        return menuCellHeight
    }
    
    override func viewDidLayoutSubviews() {
        // Update count in menu cell
        var indexPath: NSIndexPath = NSIndexPath(forRow: 1, inSection: 0)
        var cell: MenuCell? = tableView.cellForRowAtIndexPath(indexPath) as MenuCell?
        if cell == nil {
            println("Menu cell is nil?")
            return
        }
        
        var firstCount: Int = 0
        for i in 0...allTasks.count-1 {
            if allTasks[i].dueDate != nil {
                if allTasks[i].dueDate!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) {
                    firstCount++
                }
            }
        }
        cell!.countTextLabel.text = String(firstCount) // #Change
        
        var secondCount: Int = 0
        for i in 0...allTasks.count-1 {
            if allTasks[i].dueDate != nil {
                for j in 0...6 {
                    if allTasks[i].dueDate!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(j*24*60*60))) {
                        secondCount++
                        break
                    }
                }
            }
        }
        
        indexPath = NSIndexPath(forRow: 2, inSection: 0)
        cell = tableView.cellForRowAtIndexPath(indexPath) as MenuCell?
        cell!.countTextLabel.text = String(secondCount)
    }
}
