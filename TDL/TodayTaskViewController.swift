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

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count == 0 ? 1 : sectionItems[section].count as Int
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if sectionItems[indexPath.section].count > 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as     TaskCell

            cell.configureCell(sectionItems[indexPath.section][indexPath.row])
            cell.setButtonsHidden(indexPath, check: 0)
            tableView.scrollEnabled = true
            return cell as TaskCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(NoTaskCell), forIndexPath: indexPath) as     NoTaskCell
            tableView.scrollEnabled = false
            return cell as NoTaskCell
        }
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if sectionItems[indexPath.section].count > 0 {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
            isOpenTodayTaskCell[indexPath.section][indexPath.row] = isOpenTodayTaskCell[indexPath.section][indexPath.row] ? false : true

            let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as TaskCell!
            cell.setButtonsHidden(indexPath, check: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    override func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        if sectionItems[indexPath.section].count > 0 {
            return indexPath
        }
        
        return nil
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if sectionItems[indexPath.section].count > 0 {
            var extraHeight: CGFloat?
            // Extra height when task name is too long
            if interfaceOrientation.isPortrait {
                extraHeight = CGFloat(ceil(Double(sectionItems[indexPath.section][indexPath.row].name.utf16Count)/35)*14.5)
            } else {
                extraHeight = CGFloat(ceil(Double(sectionItems[indexPath.section][indexPath.row].name.utf16Count)/71)*14.5)
            }

            // Row height for open cell
            if isOpenTodayTaskCell[indexPath.section][indexPath.row] {
                return taskCellHeight + taskCellEditSectionHeight + extraHeight!
            }
        
            // Row height for closed cell
            return taskCellHeight + extraHeight!
        }
        
        // Row height for no cell
        return noTaskCellHeight
    }

    override func tableView(tableView: UITableView!, shouldHighlightRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        let cell: AnyObject? = tableView.cellForRowAtIndexPath(indexPath)
        if cell is NoTaskCell {
            return false
        }
        
        return true
    }
    
    override func tableView(tableView: UITableView!, willDisplayCell cell: UITableViewCell!, forRowAtIndexPath indexPath: NSIndexPath!) {
        //println(sectionItems[indexPath.section][indexPath.row].name)
    }
    
    func openAddTaskController(sender: AnyObject) {
        let addTaskViewController = AddTaskViewController()
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = addTaskViewController
        
        navigationController.pushViewController(addTaskViewController, animated: true)
    }

    func openEditTaskController(indexPath: NSIndexPath) {
        let editTaskViewController: EditTaskViewController = EditTaskViewController(indexPath: indexPath)
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = editTaskViewController
        
        self.navigationController.pushViewController(editTaskViewController, animated: true)
    }
}