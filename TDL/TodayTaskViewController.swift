import UIKit

var todayTasks = [[Task]]()

func updateTodayTasks() {
    todayTasks.removeAll(keepCapacity: false)
    todayTasks.append([Task]())
    todayTasks.append([Task]())
    
    // If there is any task we can proceed
    if allTasks.count > 0 {
        for i in 0...allTasks.count-1 {
            if allTasks[i].dueDate != nil {
                if !allTasks[i].dueDate!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) && allTasks [i].dueDate!.isEarlierThanDate(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) {
                    todayTasks[0].append(allTasks[i])
                }
            }
        }
        
        for i in 0...allTasks.count-1 {
            if allTasks[i].dueDate != nil {
                if allTasks[i].dueDate!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) {
                    todayTasks[1].append(allTasks[i])
                }
            }
        }
    }
}

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
        
        editTaskCell = editCell()
        
        todayTasks.append([Task]())
        todayTasks.append([Task]())
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(TodayNoTaskCell.self, forCellReuseIdentifier: NSStringFromClass(TodayNoTaskCell))
        tableView.registerClass(EditTaskCell.self, forCellReuseIdentifier: NSStringFromClass(EditTaskCell))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        editTaskCell!.position = nil
        
        updateTodayTasks()
        
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var extraCount: [Int] = [0, 0]
        if editTaskCell!.position != nil {
            for i in 0...1 {
                if editTaskCell!.position!.section == i {
                    extraCount[i] = 1
                }
            }
        }
        
        if (todayTasks[0].count + todayTasks[1].count) > 0 {
            return todayTasks[section].count > 0 ? todayTasks[section].count + extraCount[section] : 0 as Int
        } else {
            return 1 - section as Int
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (todayTasks[0].count + todayTasks[1].count) > 0 {
            if editTaskCell!.position != nil {
                if editTaskCell!.position!.section == indexPath.section && editTaskCell!.position!.row == indexPath.row-1 {
                    let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(EditTaskCell), forIndexPath: indexPath) as EditTaskCell
                    return cell as EditTaskCell
                }
            }
            
            var extraCount: [Int] = [0, 0]
            if editTaskCell!.position != nil {
                for i in 0...1 {
                    if editTaskCell!.position!.section == i && editTaskCell!.position!.row < indexPath.row-1 {
                        extraCount[i] = 1
                    }
                }
            }
            
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
            cell.configureCell(todayTasks[indexPath.section][indexPath.row - extraCount[indexPath.section]])
            return cell as TaskCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TodayNoTaskCell), forIndexPath: indexPath) as TodayNoTaskCell
        tableView.scrollEnabled = false // disable scrolling when there is no cells
        return cell as TodayNoTaskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var nextIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        if editTaskCell!.position == nil {
            editTaskCell!.position = indexPath
            tableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        } else {
            if editTaskCell!.position == indexPath {
                editTaskCell!.position = nil // Close
                tableView.deleteRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            } else {
                var previousIndexPath = NSIndexPath(forRow: editTaskCell!.position!.row+1, inSection: editTaskCell!.position!.section)
                tableView.beginUpdates()
                
                tableView.deleteRowsAtIndexPaths([previousIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                if previousIndexPath.section == indexPath.section { // check if cell is going to be added in same section
                    if indexPath.row < editTaskCell!.position!.row {
                        editTaskCell!.position = indexPath
                        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Top)
                    } else {
                        editTaskCell!.position = NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)
                        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
                    }
                } else {
                    editTaskCell!.position = indexPath
                    tableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
                }
                
                tableView.endUpdates()
            }
        }
        
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Row height for normal cell
        if (todayTasks[0].count + todayTasks[1].count) > 0 {
            return taskCellHeight
        }
        
        // Row height for "no task" cell
        return todayNoTaskCellHeight
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell: AnyObject? = tableView.cellForRowAtIndexPath(indexPath)
        if cell is TodayNoTaskCell {
            return false
        }
        
        return true
    }

    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView {
        var headerView: UIView
        var dayName: UILabel
        var descText: UILabel
        
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.95)
        
        var dayNameSize: CGSize = (todayTasks[0].count > 0 && section == 0) ? String("Overdue").sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)]) : String("Today").sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)])
        dayName = UILabel(frame: CGRectZero)
        dayName.textColor = (todayTasks[0].count > 0 && section == 0) ? UIColor.redColor() : UIColor.blackColor()
        dayName.font = UIFont.systemFontOfSize(13)
        dayName.text = (todayTasks[0].count > 0 && section == 0) ? String("Overdue") : String("Today")
        dayName.backgroundColor = UIColor.clearColor()
        
        headerView.addSubview(dayName)
        
        // Constraints
        dayName.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Left, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Right, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15+dayNameSize.width+1))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if todayTasks[0].count > 0 {
            return 30
        }
        
        return 0
    }
    
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
    
    func openEditTaskController(task: Task) {
        let editTaskViewController: EditTaskViewController = EditTaskViewController(task: task)
        
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