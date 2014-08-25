import UIKit

let listEditCellHeight: CGFloat = 35
let listEditCellButtonCornerRadius: CGFloat = 5.0

class ListEditCell: UITableViewCell {
    let deleteButton: UIButton
    let editButton: UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        deleteButton.layer.cornerRadius = listEditCellButtonCornerRadius
        deleteButton.setTitle("Delete", forState: UIControlState.Normal)
        deleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deleteButton.frame = CGRectMake(20, 5, 60, 25)
        deleteButton.backgroundColor = UIColor.redColor()
        
        editButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        editButton.layer.cornerRadius = listEditCellButtonCornerRadius
        editButton.setTitle("Edit", forState: UIControlState.Normal)
        editButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        editButton.backgroundColor = editButton.tintColor
        editButton.frame = CGRectMake(250, 5, 60, 25)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        deleteButton.addTarget(self, action: "deleteButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        editButton.addTarget(self, action: "editButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)

        contentView.addSubview(deleteButton)
        contentView.addSubview(editButton)
        
        /*deleteButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -250))
        contentView.addConstraint(NSLayoutConstraint(item: deleteButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        editButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: editButton, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 250))
        contentView.addConstraint(NSLayoutConstraint(item: editButton, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 5))
        contentView.addConstraint(NSLayoutConstraint(item: editButton, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -20))
        contentView.addConstraint(NSLayoutConstraint(item: editButton, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))*/
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setButtonsHidden(indexPath: NSIndexPath) {
        deleteButton.hidden = hiddenEditCell[indexPath.section][indexPath.row/2]
        editButton.hidden = hiddenEditCell[indexPath.section][indexPath.row/2]
    }
    
    func deleteButtonAction(sender: UIButton!) {
        let buttonCell = sender.superview?.superview as UITableViewCell
        let tableView = buttonCell.superview?.superview as UITableView
        let indexPath = tableView.indexPathForCell(buttonCell) as NSIndexPath

        let newIndexPath = NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)
        tableView.beginUpdates()
        sectionItems[indexPath.section].removeAtIndex(indexPath.row/2)
        if sectionItems[indexPath.section].count > 0 {
            for i in 0...sectionItems[indexPath.section].count-1 {
                if indexPath.row/2 <= i {
                    hiddenEditCell[indexPath.section][i] = hiddenEditCell[indexPath.section][i+1]
                }
            }
        }
        hiddenEditCell[indexPath.section][sectionItems[indexPath.section].count] = false
        
        tableView.deleteRowsAtIndexPaths([indexPath, newIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
        tableView.endUpdates()
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
        let controller: ListViewController = window.topViewController as ListViewController
        controller.openEditTaskController(indexPath)
    }
}



