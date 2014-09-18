import UIKit

class TaskViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return true
    }
    
    convenience override init() {
        self.init(style: .Plain)
        title = "Next 7 Days"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Right item to open add task controller
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return listSections.count as Int
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return listSections[section] as String
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count as Int
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
        cell.configureCell(sectionItems[indexPath.section][indexPath.row])
        cell.setButtonsHidden(indexPath, check: 1)
        return cell as TaskCell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        open[indexPath.section][indexPath.row] = open[indexPath.section][indexPath.row] ? false : true

        let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as TaskCell!
        cell.setButtonsHidden(indexPath, check: 1)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        var extraHeight: CGFloat?
        // Extra height when task name is too long
        if interfaceOrientation.isPortrait {
            extraHeight = CGFloat(ceil(Double(sectionItems[indexPath.section][indexPath.row].name.utf16Count)/35)*14.5)
        } else {
            extraHeight = CGFloat(ceil(Double(sectionItems[indexPath.section][indexPath.row].name.utf16Count)/71)*14.5)
        }
        
        // Row height for open cell
        if open[indexPath.section][indexPath.row] {
            return taskCellHeight + taskCellEditSectionHeight + extraHeight!
        }
        
        // Row height for closed cell
        return taskCellHeight + extraHeight!
    }
    
    override func tableView(tableView: UITableView!, willDisplayHeaderView view: UIView!, forSection section: Int) {
        view.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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