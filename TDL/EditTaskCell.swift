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
        completeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        completeButton.setImage(completeImage, forState: UIControlState.Normal)
        completeButton.frame = CGRectMake(20, 5, 50, 50)
        let postponeImage: UIImage = UIImage(named: "postpone-image") as UIImage!
        postponeButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        postponeButton.setImage(postponeImage, forState: UIControlState.Normal)
        postponeButton.frame = CGRectMake(135, 5, 50, 50)
        
        let editImage: UIImage = UIImage(named: "edit-image") as UIImage!
        editButton = UIButton.buttonWithType(UIButtonType.InfoDark) as! UIButton
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
        let buttonCell = sender.superview?.superview as! UITableViewCell
        let tableView = buttonCell.superview?.superview as! UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath?
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        
        window = window.rootViewController as! UINavigationController
        
        if window.topViewController is TaskViewController {
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = weekTasks[cellIndexPath!.section][cellIndexPath!.row]
            
            for i in 0...allTasks.count-1 {
                if allTasks[i] === task {
                    allTasks.removeAtIndex(i)
                    break
                }
            }
        
            editTaskCell!.position = nil
            
            updateWeekTasks()
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)

            tableView.reloadData()
            tableView.endUpdates()
        } else if window.topViewController is TodayTaskViewController {
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = todayTasks[cellIndexPath!.section][cellIndexPath!.row]
            
            for i in 0...allTasks.count-1 {
                if allTasks[i] === task {
                    allTasks.removeAtIndex(i)
                    break
                }
            }
            
            editTaskCell!.position = nil
            
            updateTodayTasks()
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            
            // Add "no task" cell if there is no cells
            if (todayTasks[0].count + todayTasks[1].count) == 0 {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            tableView.reloadData()
            tableView.endUpdates()
        } else if window.topViewController is DetailFilterViewController {
            // Change due date
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = detailFilterTasks[cellIndexPath!.row]
            
            var date: NSDate?
            for i in 0...allTasks.count-1 {
                if allTasks[i] === task {
                    allTasks.removeAtIndex(i)
                    break
                }
            }
            
            // Delete and insert rows
            editTaskCell!.position = nil
            
            updateDetailFilterTasks()
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            
            // Add no task cell if there is no cells
            if detailFilterTasks.count == 0 {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            tableView.reloadData()
            tableView.endUpdates()
        }
    }
    
    func postpone(sender: UIButton!) { // TODO: clean up
        let buttonCell = sender.superview?.superview as! UITableViewCell
        let tableView = buttonCell.superview?.superview as! UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath?
        
        if indexPath == nil {
            println("postpone button - indexPath is nil")
            return
        }
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        window = window.rootViewController as! UINavigationController

        if window.topViewController is TaskViewController {
            // Change due date
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = weekTasks[cellIndexPath!.section][cellIndexPath!.row]
            
            for i in 0...allTasks.count-1 {
                if allTasks[i] === task {
                    allTasks[i].dueDate = NSDate(timeInterval: NSTimeInterval(60*60*24), sinceDate: task.dueDate!)
                    break
                }
            }
            
            // Delete and insert rows
            editTaskCell!.position = nil
            
            updateWeekTasks()
            
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)

            if cellIndexPath!.section + 1 <= 6 {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: weekTasks[cellIndexPath!.section + 1].count - 1, inSection: cellIndexPath!.section + 1)], withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            tableView.reloadData()
            tableView.endUpdates()
        } else if window.topViewController is TodayTaskViewController {
            // Change due date
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = todayTasks[cellIndexPath!.section][cellIndexPath!.row]
            
            var date: NSDate?
            for i in 0...allTasks.count-1 {
                if allTasks[i] === task {
                    allTasks[i].dueDate = NSDate(timeInterval: NSTimeInterval(60*60*24), sinceDate: task.dueDate!)
                    date = allTasks[i].dueDate!
                    break
                }
            }
            
            // Delete and insert rows
            editTaskCell!.position = nil
            
            updateTodayTasks()

            tableView.beginUpdates()

            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.deleteRowsAtIndexPaths([cellIndexPath!], withRowAnimation: UITableViewRowAnimation.Left)
            
            if date!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) {
                // insert to Today
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: todayTasks[cellIndexPath!.section + 1].count - 1, inSection: cellIndexPath!.section + 1)], withRowAnimation: UITableViewRowAnimation.Left)
            } else if !date!.isEqualToDateIgnoringTime(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) && date!.isEarlierThanDate(NSDate(timeIntervalSinceNow: NSTimeInterval(0))) {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: todayTasks[cellIndexPath!.section].count - 1, inSection: cellIndexPath!.section)], withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            // Add no task cell if there is no cells
            if (todayTasks[0].count + todayTasks[1].count) == 0 {
                tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
            }
            
            tableView.reloadData()
            tableView.endUpdates()
        } else if window.topViewController is DetailFilterViewController {
            // Change due date
            let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            var task: Task = detailFilterTasks[cellIndexPath!.row]
            
            var date: NSDate?
            if task.dueDate != nil {
                for i in 0...allTasks.count-1 {
                    if allTasks[i] === task {
                        allTasks[i].dueDate = NSDate(timeInterval: NSTimeInterval(60*60*24), sinceDate: task.dueDate!)
                        date = allTasks[i].dueDate!
                        break
                    }
                }
                
                // Delete and insert rows
                editTaskCell!.position = nil
                
                updateDetailFilterTasks()
                
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Left)
                
                // Add no task cell if there is no cells
                if detailFilterTasks.count == 0 {
                    tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
                }
                
                tableView.reloadData()
                tableView.endUpdates()
            } else {
                var alert = UIAlertView()
                alert.title = "Error"
                alert.message = "You cannot postpone task if it has no due date. Change the due date first"
                alert.addButtonWithTitle("Back")
                alert.show()
            }
        }
    }
    
    func edit(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as! UITableViewCell
        let tableView = buttonCell.superview?.superview as! UITableView
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
        window = window.rootViewController as! UINavigationController
        
        let cellIndexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
        if window.topViewController is TaskViewController {
            let controller = window.topViewController as! TaskViewController
            controller.openEditTaskController(weekTasks[indexPath!.section][indexPath!.row - 1])
        } else if window.topViewController is TodayTaskViewController {
            let controller = window.topViewController as! TodayTaskViewController
            controller.openEditTaskController(todayTasks[indexPath!.section][indexPath!.row - 1])
        } else if window.topViewController is DetailFilterViewController {
            let controller = window.topViewController as! DetailFilterViewController
            controller.openEditTaskController(detailFilterTasks[indexPath!.row - 1])
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}