import UIKit

struct editCell {
    var open: Bool = false
    var position: NSIndexPath? = nil
}

var editTaskCell: editCell?
var weekTasks = [[Task]]()

func updateWeekTasks() {
    weekTasks.removeAll(keepCapacity: false)
    for i in 0...6 {
        weekTasks.insert([Task](), atIndex: i)
    }
    
    if allTasks.count > 0 {
        for i in 0...allTasks.count-1 {
            if allTasks[i].dueDate != nil {
                for j in 0...6 {
                    if allTasks[i].dueDate!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(j*24*60*60))) {
                        weekTasks[j].append(allTasks[i])
                        break
                    }
                }
            }
        }
    }
}

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
        
        editTaskCell = editCell()

        // Right item to open add task controller
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(EditTaskCell.self, forCellReuseIdentifier: NSStringFromClass(EditTaskCell))
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        editTaskCell!.position = nil
        updateWeekTasks()
        tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return namesForSections.count as Int
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var extraCount: Int = 0
        if editTaskCell!.position != nil {
            if editTaskCell!.position!.section == section {
                extraCount = 1
            }
        }
        
        return weekTasks[section].count + extraCount as Int
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if editTaskCell!.position != nil {
            if editTaskCell!.position!.section == indexPath.section && editTaskCell!.position!.row == indexPath.row-1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(EditTaskCell), forIndexPath: indexPath) as EditTaskCell
                return cell as EditTaskCell
            }
        }

        var extraCount: Int = 0
        if editTaskCell!.position != nil {
            if editTaskCell!.position!.section == indexPath.section && editTaskCell!.position!.row < indexPath.row-1 {
               extraCount = 1
            }
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
        cell.configureCell(weekTasks[indexPath.section][indexPath.row - extraCount])
        //cell.setButtonsHidden(NSIndexPath(forRow: indexPath.row - extraCount, inSection: indexPath.section), check: 1)
        return cell as TaskCell
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
        // Row height for closed cell
        return taskCellHeight
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

        var dayNameSize: CGSize = String(namesForSections[section].day).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(13)])
        dayName = UILabel(frame: CGRectZero)
        dayName.textColor = UIColor.blackColor()
        dayName.font = UIFont.systemFontOfSize(13)
        dayName.text = String(namesForSections[section].day)
        dayName.backgroundColor = UIColor.clearColor()
        
        descText = UILabel(frame: CGRectZero)
        descText.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        descText.font = UIFont.systemFontOfSize(10)
        descText.text = String(namesForSections[section].desc)
        descText.backgroundColor = UIColor.clearColor()

        headerView.addSubview(dayName)
        headerView.addSubview(descText)

        // Constraints
        dayName.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Left, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Right, relatedBy: .Equal, toItem: headerView, attribute: .Left, multiplier: 1, constant: 15+dayNameSize.width+1))
        headerView.addConstraint(NSLayoutConstraint(item: dayName, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        descText.setTranslatesAutoresizingMaskIntoConstraints(false)
        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Left, relatedBy: .Equal, toItem: dayName, attribute: .Right, multiplier: 1, constant: 5))
        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Top, relatedBy: .Equal, toItem: headerView, attribute: .Top, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Right, relatedBy: .Equal, toItem: headerView, attribute: .Right, multiplier: 1, constant: 0))
        headerView.addConstraint(NSLayoutConstraint(item: descText, attribute: .Bottom, relatedBy: .Equal, toItem: headerView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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