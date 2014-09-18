import UIKit

let taskCellHeight: CGFloat = 40
let taskCellEditSectionHeight: CGFloat = 60

let taskCellTextFontSize: CGFloat = 12
let taskCellTagFontSize: CGFloat = 9

class TaskCell: UITableViewCell {
    let priorityViewLabel: UILabel
    let nameTextLabel: UILabel
    let tagTextLabel: UILabel
    let circleViewLabel: UILabel
    let separatorLineLabel: UILabel
    let completeButton: UIButton
    let postponeButton: UIButton
    let editButton: UIButton

    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        priorityViewLabel = UILabel(frame: CGRectZero)
        
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(taskCellTextFontSize)
        nameTextLabel.numberOfLines = 0
        nameTextLabel.sizeToFit()
        nameTextLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        nameTextLabel.textAlignment = NSTextAlignment.Left
        nameTextLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        
        tagTextLabel = UILabel(frame: CGRectZero)
        tagTextLabel.backgroundColor = UIColor.whiteColor()
        tagTextLabel.font = UIFont.systemFontOfSize(taskCellTagFontSize)
        tagTextLabel.numberOfLines = 1
        tagTextLabel.textAlignment = NSTextAlignment.Left;
        tagTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        
        circleViewLabel = UILabel(frame: CGRectZero)
        circleViewLabel.layer.cornerRadius = 4.5
        
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        let completeImage: UIImage = UIImage(named: "complete-image") as UIImage
        completeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        completeButton.setImage(completeImage, forState: UIControlState.Normal)
        completeButton.frame = CGRectMake(20, taskCellHeight, 50, 50)

        let postponeImage: UIImage = UIImage(named: "postpone-image") as UIImage
        postponeButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        postponeButton.setImage(postponeImage, forState: UIControlState.Normal)
        postponeButton.frame = CGRectMake(135, taskCellHeight, 50, 50)
        
        let editImage: UIImage = UIImage(named: "edit-image") as UIImage
        editButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        editButton.setImage(editImage, forState: UIControlState.Normal)
        editButton.frame = CGRectMake(250, taskCellHeight, 50, 50)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        completeButton.addTarget(self, action: "complete:", forControlEvents: UIControlEvents.TouchUpInside)
        postponeButton.addTarget(self, action: "postpone:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.addTarget(self, action: "edit:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Content subview
        contentView.addSubview(priorityViewLabel)
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(tagTextLabel)
        contentView.addSubview(circleViewLabel)
        contentView.addSubview(separatorLineLabel)
        contentView.addSubview(completeButton)
        contentView.addSubview(postponeButton)
        contentView.addSubview(editButton)
        
        // Constraints
        priorityViewLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: priorityViewLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: priorityViewLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 2))
        contentView.addConstraint(NSLayoutConstraint(item: priorityViewLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 3))
        contentView.addConstraint(NSLayoutConstraint(item: priorityViewLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -2))
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -55))
        
        tagTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -29))
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -10))
        
        circleViewLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: circleViewLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -24))
        contentView.addConstraint(NSLayoutConstraint(item: circleViewLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        contentView.addConstraint(NSLayoutConstraint(item: circleViewLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -15))
        contentView.addConstraint(NSLayoutConstraint(item: circleViewLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -11))
        
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func setButtonsHidden(indexPath: NSIndexPath, check: Int) {
        completeButton.hidden = check == 2 ? !isOpenDetailTagCell[indexPath.row] : (check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row])
        postponeButton.hidden = check == 2 ? !isOpenDetailTagCell[indexPath.row] : (check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row])
        editButton.hidden = check == 2 ? !isOpenDetailTagCell[indexPath.row] : (check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row])
    }
    
    func configureCell(task: Task) {
        priorityViewLabel.backgroundColor = priorityColors[task.priority]
        nameTextLabel.text = task.name
        tagTextLabel.text = task.tag.name
        circleViewLabel.layer.backgroundColor = task.tag.color.CGColor
    }

    func complete(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        
        window = window.rootViewController as UINavigationController
        let menuController: MenuViewController = (window as SlideNavigationController).sharedInstance().menu as MenuViewController

        sectionItems[indexPath.section].removeAtIndex(indexPath.row)
        updateOpenCells(indexPath)
        menuController.updateCount()

        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
        // Add no task cell if there is no cells
        if sectionItems[indexPath.section].count == 0 && window.topViewController is TodayTaskViewController {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.endUpdates()
    }
    
    func postpone(sender: UIButton!) { // TODO: clean up
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath
        
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        window = window.rootViewController as UINavigationController

        // Change completion date, insert task to tasks list and delete from current section
        var task: Task = sectionItems[indexPath.section][indexPath.row]
        task.completionDate = NSDate(timeInterval: NSTimeInterval(60*60*24), sinceDate: task.completionDate)
        sectionItems[indexPath.section+1].insert(task, atIndex: sectionItems[indexPath.section+1].count)
        sectionItems[indexPath.section].removeAtIndex(indexPath.row)
        
        updateOpenCells(indexPath)
        open[indexPath.section+1].insert(false, atIndex: sectionItems[indexPath.section+1].count-1)
        
        // Delete and insert rows
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

        // we cannot insert new row in section+1 if it is today task view controller
        if window.topViewController is TaskViewController {
            tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: sectionItems[indexPath.section+1].count-1, inSection: indexPath.section+1)], withRowAnimation: UITableViewRowAnimation.Left)
        }
        
        // Add no task cell if there is no cells
        if sectionItems[indexPath.section].count == 0 && window.topViewController is TodayTaskViewController {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.endUpdates()
    }
    
    func updateOpenCells(indexPath: NSIndexPath) {
        if sectionItems[indexPath.section].count > 0 {
            for i in 0...sectionItems[indexPath.section].count-1 {
                if indexPath.row <= i {
                    if indexPath.section == 0 {
                        isOpenTodayTaskCell[indexPath.section][i] = isOpenTodayTaskCell[indexPath.section][i+1]
                    }
                    
                    open[indexPath.section][i] = open[indexPath.section][i+1]
                }
            }
        }
        
        open[indexPath.section][sectionItems[indexPath.section].count] = false
        if indexPath.section == 0 {
            isOpenTodayTaskCell[indexPath.section][sectionItems[indexPath.section].count] = false
        }
    }
    
    func edit(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath
        
        // Search for main window
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        window = window.rootViewController as UINavigationController

        if window.topViewController is TaskViewController {
            let controller = window.topViewController as TaskViewController
            controller.openEditTaskController(indexPath)
        } else {
            let controller = window.topViewController as TodayTaskViewController
            controller.openEditTaskController(indexPath)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}