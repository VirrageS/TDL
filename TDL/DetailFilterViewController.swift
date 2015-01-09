import UIKit

var detailFilterTasks = [Task]()
var detailFilterTitle: String?

func updateDetailFilterTasks() {
    detailFilterTasks.removeAll(keepCapacity: false)
    
    switch (detailFilterTitle! as String) {
    case "Priority 1":
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].priority == 0 {
                    detailFilterTasks.append(allTasks[i])
                }
            }
        }
        break
        
    case "Priority 2":
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].priority == 1 {
                    detailFilterTasks.append(allTasks[i])
                }
            }
        }
        break
        
    case "Priority 3":
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].priority == 2 {
                    detailFilterTasks.append(allTasks[i])
                }
            }
        }
        break
        
    case "Priority 4":
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].priority == 3 {
                    detailFilterTasks.append(allTasks[i])
                }
            }
        }
        break
        
    case "View all":
        detailFilterTasks = allTasks
        break
        
    case "No due date":
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].dueDate == nil {
                    detailFilterTasks.append(allTasks[i])
                }
            }
        }
        break
        
    default:
        break
    }
}

class DetailFilterViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        title = text
        
        detailFilterTitle = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTaskCell = editCell()
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(NoTaskCell.self, forCellReuseIdentifier: NSStringFromClass(NoTaskCell))
        tableView.registerClass(EditTaskCell.self, forCellReuseIdentifier: NSStringFromClass(EditTaskCell))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        editTaskCell!.position = nil
        updateDetailFilterTasks()
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var extraCount: Int = 0
        if editTaskCell!.position != nil {
            if editTaskCell!.position!.section == section {
                extraCount = 1
            }
        }
        
        return (detailFilterTasks.count > 0 ? (detailFilterTasks.count + extraCount) : 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (detailFilterTasks.count > 0) {
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
            cell.configureCell(detailFilterTasks[indexPath.row - extraCount])
            return cell as TaskCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(NoTaskCell), forIndexPath: indexPath) as NoTaskCell
        tableView.scrollEnabled = false
        return cell as NoTaskCell
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
        if (detailFilterTasks.count > 0) {
            return taskCellHeight
        }
        
        return noTaskCellHeight
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell: AnyObject? = tableView.cellForRowAtIndexPath(indexPath)
        if cell is NoTaskCell {
            return false
        }
        
        return true
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
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}