import UIKit

let menuCellHeight: CGFloat = 40
let menuCellTextFontSize: CGFloat = 16
let menuCellCountFontSize: CGFloat = 12

class MenuCell: UITableViewCell {
    let nameTextLabel: UILabel
    let countTextLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(menuCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor.blackColor()
        
        countTextLabel = UILabel(frame: CGRectZero)
        countTextLabel.backgroundColor = UIColor.whiteColor()
        countTextLabel.font = UIFont.systemFontOfSize(menuCellCountFontSize)
        countTextLabel.numberOfLines = 1
        countTextLabel.textAlignment = NSTextAlignment.Left;
        countTextLabel.textColor = UIColor.blackColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(nameTextLabel)
        contentView.addSubview(countTextLabel)
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
        
        countTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 200))
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 12))
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func configure(text: String, count: Int?) {
        nameTextLabel.text = text
        if count != nil {
            countTextLabel.text = String(count!)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}