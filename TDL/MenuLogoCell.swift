import UIKit

let menuLogoCellHeightPortrait: CGFloat = 64.4
let menuLogoCellHeightLandscape: CGFloat = 32.5
let menuLogoCellTextFontSize: CGFloat = 16
let menuLogoCellColor: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)

class MenuLogoCell: UITableViewCell {
    let nameTextLabel: UILabel
    let separatorLineLabel: UILabel
    let tdlImage: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        // name label
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.font = UIFont(name: "Helvetica-Bold", size: menuLogoCellTextFontSize)
        nameTextLabel.text = "TDL"
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor.blackColor()

        // separator line
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        // tdl logo
        tdlImage = UIImageView(frame: CGRectZero)
        tdlImage.image = UIImage(named: "tdl-icon")!
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // adding views
        contentView.addSubview(nameTextLabel)
        contentView.addSubview(separatorLineLabel)
        contentView.addSubview(tdlImage)
        contentView.backgroundColor = menuLogoCellColor
        
        // name label constrains
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 60))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 35))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 100))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 50))
        
        // separator line between two cells constraints
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))

        // TDL Logo constraints
        tdlImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 15))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 25))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 45))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 55))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}