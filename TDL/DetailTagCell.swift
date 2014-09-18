import UIKit

let detailTagCellHeight: CGFloat = 35

let detailTagCellTextFontSize: CGFloat = 12
let detailTagCellTagFontSize: CGFloat = 9

class DetailTagCell: UITableViewCell {
    let nameTextLabel: UILabel
    let tagTextLabel: UILabel
    let circleViewLabel: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(detailTagCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        
        tagTextLabel = UILabel(frame: CGRectZero)
        tagTextLabel.backgroundColor = UIColor.whiteColor()
        tagTextLabel.font = UIFont.systemFontOfSize(detailTagCellTagFontSize)
        tagTextLabel.numberOfLines = 1
        tagTextLabel.textAlignment = NSTextAlignment.Left;
        tagTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 142/255, alpha: 1)
        
        circleViewLabel = UILabel(frame: CGRectMake(235, 12, 10, 10)) // #Change Change to constraint
        circleViewLabel.layer.cornerRadius = 5
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(tagTextLabel)
        contentView.addSubview(circleViewLabel)
        
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

    func configureWithList(task: Task) {
        nameTextLabel.text = task.name
        tagTextLabel.text = task.tag.name
        circleViewLabel.layer.backgroundColor = task.tag.color.CGColor
    }
}