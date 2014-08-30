import UIKit

let menuLogoCellHeight: CGFloat = 64.5
let menuLogoCellTextFontSize: CGFloat = 30
let menuLogoCellColor: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)

class MenuLogoCell: UITableViewCell {
    let nameTextLabel: UILabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = menuLogoCellColor
        nameTextLabel.font = UIFont.systemFontOfSize(menuLogoCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.text = "TDL Logo"
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor.blackColor()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameTextLabel)
        contentView.backgroundColor = menuLogoCellColor
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}