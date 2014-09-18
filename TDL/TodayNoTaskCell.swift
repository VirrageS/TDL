import UIKit

let noTaskCellHeight: CGFloat = 300
let noTaskCellTextFontSize: CGFloat = 18

class NoTaskCell: UITableViewCell {
    let nameTextLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(noTaskCellTextFontSize)
        nameTextLabel.numberOfLines = 2
        nameTextLabel.text = "No tasks for today.\nHave a nice day :)"
        nameTextLabel.textAlignment = NSTextAlignment.Center
        nameTextLabel.textColor = UIColor.blackColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameTextLabel)
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 50))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}