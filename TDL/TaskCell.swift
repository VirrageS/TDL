import UIKit

let taskCellHeight: CGFloat = 55
let taskCellEditSectionHeight: CGFloat = 60

let taskCellTextFontSize: CGFloat = 17
let taskCellDateFontSize: CGFloat = 10
let taskCellTagFontSize: CGFloat = 9

class TaskCell: UITableViewCell {
    let priorityViewLabel: UILabel
    let nameTextLabel: UILabel
    let dateTextLabel: UILabel
    let tagTextLabel: UILabel
    let circleViewLabel: UILabel
    let separatorLineLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        priorityViewLabel = UILabel(frame: CGRectZero)
        
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(taskCellTextFontSize)
        nameTextLabel.numberOfLines = 0
        nameTextLabel.sizeToFit()
        nameTextLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        nameTextLabel.textAlignment = NSTextAlignment.Left
        nameTextLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1)
        
        dateTextLabel = UILabel(frame: CGRectZero)
        dateTextLabel.backgroundColor = UIColor.clearColor()
        dateTextLabel.font = UIFont.systemFontOfSize(taskCellDateFontSize)
        dateTextLabel.numberOfLines = 1
        dateTextLabel.textAlignment = NSTextAlignment.Left;
        dateTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        
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
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Content subview
        contentView.addSubview(priorityViewLabel)
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(dateTextLabel)
        contentView.addSubview(tagTextLabel)
        contentView.addSubview(circleViewLabel)
        contentView.addSubview(separatorLineLabel)
        
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
        
        dateTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: dateTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: dateTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -10))
        
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

    func configureCell(task: Task) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE" // #Change - if date is > 7 days should set format to "dd MMM yyyy"
        dateTextLabel.text = (task.dueDate == nil ? "No due date" : dateFormatter.stringFromDate(task.dueDate!))
        
        priorityViewLabel.backgroundColor = priorityColors[task.priority]
        nameTextLabel.text = task.name
        
        if task.tag != nil && task.tag?.enabled != false {
            tagTextLabel.text = task.tag!.name
            circleViewLabel.layer.backgroundColor = task.tag!.color.CGColor
        } else {
            tagTextLabel.text = ""
            circleViewLabel.layer.backgroundColor = UIColor.clearColor().CGColor
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}