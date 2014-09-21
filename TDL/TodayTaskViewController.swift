import UIKit

class TodayTaskViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return true
    }
    
    convenience override init() {
        self.init(style: .Plain)
        title = "Today"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem

        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(NoTaskCell.self, forCellReuseIdentifier: NSStringFromClass(NoTaskCell))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #Change - more numberOfSections if there is task with date < NSDate().date
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks[section].count == 0 ? 1 : allTasks[section].count as Int
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if allTasks[indexPath.section].count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as     TaskCell

            cell.configureCell(allTasks[indexPath.section][indexPath.row])
            cell.setButtonsHidden(indexPath, check: 0)
            tableView.scrollEnabled = true
            return cell as TaskCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(NoTaskCell), forIndexPath: indexPath) as     NoTaskCell
            tableView.scrollEnabled = false
            return cell as NoTaskCell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if allTasks[indexPath.section].count > 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            isOpenTodayTaskCell[indexPath.section][indexPath.row] = isOpenTodayTaskCell[indexPath.section][indexPath.row] ? false : true

            let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as TaskCell!
            cell.setButtonsHidden(indexPath, check: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if allTasks[indexPath.section].count > 0 {
            var extraHeight: CGFloat?
            // Extra height when task name is too long
            if interfaceOrientation.isPortrait {
                extraHeight = CGFloat(ceil(Double(allTasks[indexPath.section][indexPath.row].name.utf16Count)/35)*14.5)
            } else {
                extraHeight = CGFloat(ceil(Double(allTasks[indexPath.section][indexPath.row].name.utf16Count)/71)*14.5)
            }

            // Row height for isOpenNext7DaysTaskCell cell
            if isOpenTodayTaskCell[indexPath.section][indexPath.row] {
                return taskCellHeight + taskCellEditSectionHeight + extraHeight!
            }
        
            // Row height for closed cell
            return taskCellHeight + extraHeight!
        }
        
        // Row height for no cell
        return noTaskCellHeight
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell: AnyObject? = tableView.cellForRowAtIndexPath(indexPath)
        if cell is NoTaskCell {
            return false
        }
        
        return true
    }
    
    // #Change - add view for header - "Today" and if there is any date before so set it up also
//    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
//        var headerView: UIView
//        var dayName: UILabel
//        var descText: UILabel
//        
//        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
//        headerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.95)
//        
//        var dayNameSize: CGSize = String(namesForSections[section].day).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)])
//        dayName = UILabel(frame: CGRectZero)
//        dayName.textColor = UIColor.blackColor()
//        dayName.font = UIFont.systemFontOfSize(13)
//        dayName.text = String(namesForSections[section].day)
//        dayName.backgroundColor = UIColor.clearColor()
//        
//        descText = UILabel(frame: CGRectZero)
//        descText.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
//        descText.font = UIFont.systemFontOfSize(10)
//        descText.text = String(namesForSections[section].desc)
//        descText.backgroundColor = UIColor.clearColor()
//        
//        headerView.addSubview(dayName)
//        headerView.addSubview(descText)
//        
//        // Constraints
//        dayName.setTranslatesAutoresizingMaskIntoConstraints(false)
//        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Left, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15))
//        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1, constant: 0))
//        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Right, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15+dayNameSize.width+1))
//        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1, constant: 0))
//        
//        descText.setTranslatesAutoresizingMaskIntoConstraints(false)
//        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Left, relatedBy: .Equal, toItem: dayName, attribute: .Right, multiplier: 1, constant: 5))
//        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1, constant: 0))
//        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Right, relatedBy: .Equal, toItem: headerView, attribute: .Right, multiplier: 1, constant: 0))
//        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1, constant: 0))
//        
//        return headerView
//    }
//    
//    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }

    func openAddTaskController(sender: AnyObject) {
        let addTaskViewController = AddTaskViewController()
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = addTaskViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openAddTaskController - navigationController is nil")
            return
        }

        navigationController!.pushViewController(addTaskViewController, animated: true)
    }

    func openEditTaskController(indexPath: NSIndexPath) {
        let editTaskViewController: EditTaskViewController = EditTaskViewController(indexPath: indexPath)
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = editTaskViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openEditTaskController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(editTaskViewController, animated: true)
    }
}