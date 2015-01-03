import UIKit

let editTaskCellHeight: CGFloat = 40
let editTaskCellTextFontSize: CGFloat = 17

class EditTaskCell: UITableViewCell {
    let separatorLineLabel: UILabel
    let completeButton: UIButton
    let postponeButton: UIButton
    let editButton: UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        
        let completeImage: UIImage = UIImage(named: "complete-image") as UIImage!
        completeButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        completeButton.setImage(completeImage, forState: UIControlState.Normal)
        completeButton.frame = CGRectMake(20, 5, 50, 50)
        let postponeImage: UIImage = UIImage(named: "postpone-image") as UIImage!
        postponeButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        postponeButton.setImage(postponeImage, forState: UIControlState.Normal)
        postponeButton.frame = CGRectMake(135, 5, 50, 50)
        
        let editImage: UIImage = UIImage(named: "edit-image") as UIImage!
        editButton = UIButton.buttonWithType(UIButtonType.InfoDark) as UIButton
        editButton.setImage(editImage, forState: UIControlState.Normal)
        editButton.frame = CGRectMake(250, 5, 50, 50)
        
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 0.2)
        
        completeButton.addTarget(self, action: "complete:", forControlEvents: UIControlEvents.TouchUpInside)
        postponeButton.addTarget(self, action: "postpone:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Content subview
        contentView.addSubview(separatorLineLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(postponeButton)
        contentView.addSubview(editButton)
        
        // Constraints
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func complete(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath?
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        
        window = window.rootViewController as UINavigationController
        
        let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
        allTasks[cellIndexPath!.section].removeAtIndex(cellIndexPath!.row)
        
        editTaskCell!.position = nil
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        
        // Add "no task" cell if there is no cells
        if allTasks[cellIndexPath!.section].count == 0 && window.topViewController is TodayTaskViewController {
            tableView.insertRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.endUpdates()
    }
    
    func postpone(sender: UIButton!) { // TODO: clean up
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath?
        
        if indexPath == nil {
            println("postpone button - indexPath is nil")
            return
        }
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        window = window.rootViewController as UINavigationController
        
        // Change due date, insert task to tasks list and delete from current section
        let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
        var task: Task = allTasks[cellIndexPath!.section][cellIndexPath!.row]
        task.dueDate = NSDate(timeInterval: NSTimeInterval(60*60*24), sinceDate: task.dueDate!)
        allTasks[cellIndexPath!.section + 1].insert(task, atIndex: allTasks[cellIndexPath!.section+1].count)
        allTasks[cellIndexPath!.section].removeAtIndex(cellIndexPath!.row)

        // Delete and insert rows
        editTaskCell!.position = nil
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        
        // We cannot insert new row in section+1 if it is today task view controller
        if window.topViewController is TaskViewController {
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: allTasks[cellIndexPath!.section+1].count - 1, inSection: cellIndexPath!.section + 1)], withRowAnimation: UITableViewRowAnimation.Left)
        }
        
        // Add no task cell if there is no cells
        if allTasks[cellIndexPath!.section].count == 0 && window.topViewController is TodayTaskViewController {
            tableView.insertRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.endUpdates()
    }
    
    func edit(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath?
        
        // Check if indexPath is not nil
        if indexPath == nil {
            println("edit button - indexPath is nil")
            return
        }
        
        // Search for main window
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        window = window.rootViewController as UINavigationController
        
        let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
        if window.topViewController is TaskViewController {
            let controller = window.topViewController as TaskViewController
            controller.openEditTaskController(cellIndexPath!)
        } else {
            let controller = window.topViewController as TodayTaskViewController
            controller.openEditTaskController(cellIndexPath!)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}