import UIKit

let tagCellHeight: CGFloat = 50
let tagCellTextFontSize: CGFloat = 15
let tagCellCountTextFontSize: CGFloat = 16

class TagCell: UITableViewCell {
    let nameTextLabel: UILabel
    let circleViewLabel: UILabel
    let countTextLabel: UILabel
    let separatorLineLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(tagCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left
        nameTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        circleViewLabel = UILabel(frame: CGRectMake(25, 15, 20, 20))
        circleViewLabel.layer.cornerRadius = 10
        
        countTextLabel = UILabel(frame: CGRectZero)
        countTextLabel.backgroundColor = UIColor.whiteColor()
        countTextLabel.font = UIFont.systemFontOfSize(tagCellCountTextFontSize)
        countTextLabel.numberOfLines = 1
        countTextLabel.textAlignment = NSTextAlignment.Left
        countTextLabel.textColor = UIColor.lightGrayColor()
        
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(circleViewLabel)
        contentView.addSubview(countTextLabel)
        contentView.addSubview(separatorLineLabel)
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 70))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 17))
        
        countTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 16))
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -50))
        
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func configure(row: Int) {
        nameTextLabel.text = allTags[row].name
        circleViewLabel.layer.backgroundColor = allTags[row].color.CGColor
        
        var count: Int = 0
        if allTasks.count > 0 {
            for i in 0...allTasks.count-1 {
                if allTasks[i].tag == nil {
                    if allTags[row].name.lowercaseString == "none" {
                        count++
                    }
                } else {
                    if allTasks[i].tag!.name == allTags[row].name {
                        count++
                    }
                }
            }
        }
        
        countTextLabel.text = String(count)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}