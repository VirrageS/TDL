import UIKit

let cellTextFontSize: CGFloat = 12
let cellTagTextFontSize: CGFloat = 9



class TaskViewController: UITableViewController {
    convenience override init() {
        self.init(style: .Plain)
        title = "Next 7 Days"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()



        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        let image: UIImage = UIImage(named: "menu-button") as UIImage
        let menuButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "backToMenuController:")
        //barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "openMenuController:")
        navigationItem.leftBarButtonItem = menuButtonItem
        
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        //ad items from file
        //loadInitialData()
        
    }
    
    func backToMenuController(sender: AnyObject) {
        navigationController.popViewControllerAnimated(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return sectionItems.count as Int
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return listSections[section] as String
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count as Int
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
        cell.configureWithList(sectionItems[indexPath.section][indexPath.row])
        cell.setButtonsHidden(indexPath, check: 1)
        return cell as TaskCell
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        open[indexPath.section][indexPath.row] = open[indexPath.section][indexPath.row] ? false : true
        //println("\(indexPath.section) \(indexPath.row) \(open[indexPath.section][indexPath.row])")
        
        let cell: TaskCell = tableView.cellForRowAtIndexPath(indexPath) as TaskCell!
        cell.setButtonsHidden(indexPath, check: 1)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        // row height for open cell
        //println("\(indexPath.section) \(indexPath.row) \(open[indexPath.section][indexPath.row])")
        if open[indexPath.section][indexPath.row] {
            return taskCellHeight + taskCellEditSectionHeight
        }
            
        return taskCellHeight
    }
    
    func openAddTaskController(sender: AnyObject) {
        let addTaskViewController = AddTaskViewController()
        navigationController.pushViewController(addTaskViewController, animated: true)
    }
    
    func openMenuController(sender: AnyObject) {
        let menuViewController = MenuViewController()
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    func openEditTaskController(indexPath: NSIndexPath) {
        let editTaskViewController: EditTaskViewController = EditTaskViewController(indexPath: indexPath)
        self.navigationController.pushViewController(editTaskViewController, animated: true)
    }
    
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let newIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
            
            tableView.beginUpdates()
                sectionItems[indexPath.section].removeAtIndex(indexPath.row/2)

                for i in 0...sectionItems[indexPath.section].count-1 {
                    hiddenEditCell[indexPath.section][i] = hiddenEditCell[indexPath.section][i+1]
                }
                hiddenEditCell[indexPath.section][sectionItems[indexPath.section].count] = false
            
                tableView.deleteRowsAtIndexPaths([indexPath, newIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.endUpdates()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func updateData() {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let finalPath = documentsDirectory.stringByAppendingPathComponent("tdl.plist") as String
    NSKeyedArchiver.archiveRootObject(self.listItems, toFile: finalPath)
    }
    
    func loadInitialData() {
    let finalPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingPathComponent("tdl.plist") as String
    if NSFileManager.defaultManager().fileExistsAtPath(finalPath) {
    listItems = NSKeyedUnarchiver.unarchiveObjectWithFile(finalPath) as NSMutableArray
    }
    }
    */
    
    /*override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
    let label: UILabel = UILabel()
    label.frame = CGRectMake(0, 0, 320, 30)
    label.backgroundColor = UIColor.lightGrayColor()
    label.font = UIFont.boldSystemFontOfSize(18)
    label.text = listSections[section]
    
    let headerView: UIView = UIView()
    headerView.addSubview(label)
    return headerView
    }*/
}