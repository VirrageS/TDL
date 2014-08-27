import UIKit

let taskCellHeight: CGFloat = 35
let taskCellButtonCornerRadius: CGFloat = 5.0
let taskCellEditSectionHeight: CGFloat = 60

class TaskCell: UITableViewCell {
    let nameTextLabel: UILabel
    let tagTextLabel: UILabel
    let circleViewLabel: UILabel
    let completeButton: UIButton
    let postponeButton: UIButton
    let editButton: UIButton
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(cellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        tagTextLabel = UILabel(frame: CGRectZero)
        tagTextLabel.backgroundColor = UIColor.whiteColor()
        tagTextLabel.font = UIFont.systemFontOfSize(cellTagTextFontSize)
        tagTextLabel.numberOfLines = 1
        tagTextLabel.textAlignment = NSTextAlignment.Left;
        tagTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        circleViewLabel = UILabel(frame: CGRectMake(235, 12, 10, 10))
        circleViewLabel.layer.cornerRadius = 5
        
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
        editButton.addTarget(self, action: "editButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(tagTextLabel)
        contentView.addSubview(circleViewLabel)
//        contentView.addSubview(deleteButton)
        contentView.addSubview(completeButton)
        contentView.addSubview(postponeButton)
        contentView.addSubview(editButton)
        
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        tagTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 250))
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 12))
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: tagTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonsHidden(indexPath: NSIndexPath, check: Int) {
        completeButton.hidden = check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row]
        postponeButton.hidden = check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row]
        editButton.hidden = check == 1 ? !open[indexPath.section][indexPath.row] : !isOpenTodayTaskCell[indexPath.section][indexPath.row]
    }
    
    func configureWithList(task: Task) {
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

        sectionItems[indexPath.section].removeAtIndex(indexPath.row)
        if sectionItems[indexPath.section].count > 0 {
            for i in 0...sectionItems[indexPath.section].count-1 {
                if indexPath.row <= i {
                    isOpenTodayTaskCell[indexPath.section][i] = isOpenTodayTaskCell[indexPath.section][i+1]
                    open[indexPath.section][i] = open[indexPath.section][i+1]
                }
            }
        }

        open[indexPath.section][sectionItems[indexPath.section].count] = false
        isOpenTodayTaskCell[indexPath.section][sectionItems[indexPath.section].count] = false
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        if sectionItems[indexPath.section].count == 0 && window.topViewController is TodayTaskViewController {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        tableView.endUpdates()
    }
    
    func postpone(sender: UIButton!) {
        println("postpone button tapped")
    }
    
    func editButtonAction(sender: UIButton!) {
        // for index path
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath
        
        // search window
        var window: AnyObject = sender.superview!
        while !(window is UIWindow) {
            window = window.superview!!
        }
        
        window = window.rootViewController as UINavigationController
        if window.topViewController is TaskViewController {
            let controller: TaskViewController = window.topViewController as TaskViewController
            controller.openEditTaskController(indexPath)
        } else {
            let controller: TodayTaskViewController = window.topViewController as TodayTaskViewController
            controller.openEditTaskController(indexPath)
        }
    }
}