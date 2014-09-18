import UIKit

let menuLogoCellHeightPortrait: CGFloat = 64.4
let menuLogoCellHeightLandscape: CGFloat = 32.5
let menuLogoCellTextFontSize: CGFloat = 14
let menuLogoCellColor: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)

class MenuLogoCell: UITableViewCell {
    let nameTextLabel: UILabel
    let separatorLineLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = menuLogoCellColor
        nameTextLabel.font = UIFont.systemFontOfSize(menuLogoCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.text = "TDL"
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor.blackColor()
        
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(separatorLineLabel)
        contentView.backgroundColor = menuLogoCellColor
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .GreaterThanOrEqual, toItem: contentView, attribute: .Top, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -10))
        
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}