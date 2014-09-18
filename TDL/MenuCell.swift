import UIKit

let menuCellHeight: CGFloat = 40
let menuCellTextFontSize: CGFloat = 13
let menuCellCountFontSize: CGFloat = 12
let menuCellColor: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)

class MenuCell: UITableViewCell {
    let nameTextLabel: UILabel
    let countTextLabel: UILabel
    let iconImageView: UIImageView
    var separatorLineLabel: UILabel
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = menuCellColor
        nameTextLabel.font = UIFont.systemFontOfSize(menuCellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor.blackColor()
        
        countTextLabel = UILabel(frame: CGRectZero)
        countTextLabel.backgroundColor = menuCellColor
        countTextLabel.font = UIFont.systemFontOfSize(menuCellCountFontSize)
        countTextLabel.numberOfLines = 1
        countTextLabel.textAlignment = NSTextAlignment.Left;
        countTextLabel.textColor = UIColor.blackColor()
        
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)

        iconImageView = UIImageView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(countTextLabel)
        contentView.addSubview(separatorLineLabel)
        contentView.backgroundColor = menuCellColor
        
        iconImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 20))
        contentView.addConstraint(NSLayoutConstraint(item: iconImageView, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 8))
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: iconImageView, attribute: .Left, multiplier: 1, constant: 40))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 12))
        
        countTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 13))
        contentView.addConstraint(NSLayoutConstraint(item: countTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: -80))
        
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func configure(text: String) {
        nameTextLabel.text = text

        var image: UIImage
        switch(nameTextLabel.text) {
        case "Today":
            image = UIImage(named: "today-icon")
            break
        case "Next 7 Days":
            image = UIImage(named: "next7days-icon")
            break
        case "Tags":
            image = UIImage(named: "tag-icon")
            break
        default:
            image = UIImage()
            break
        }

        iconImageView.image = image
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}