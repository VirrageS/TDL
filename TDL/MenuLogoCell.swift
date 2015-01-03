import UIKit

let menuLogoCellHeightPortrait: CGFloat = 64.4
let menuLogoCellHeightLandscape: CGFloat = 32.5
let menuLogoCellTextFontSize: CGFloat = 16
let menuLogoCellColor: UIColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)

class MenuLogoCell: UITableViewCell {
    let separatorLineLabel: UILabel
    let tdlImage: UIImageView
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        separatorLineLabel = UILabel(frame: CGRectZero)
        separatorLineLabel.backgroundColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1.0)
        
        tdlImage = UIImageView(frame: CGRectZero)
        tdlImage.image = UIImage(named: "tdl-icon")!
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(separatorLineLabel)
        contentView.addSubview(tdlImage)
        contentView.backgroundColor = menuLogoCellColor
        
        separatorLineLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -0.5))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: separatorLineLabel, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))

        tdlImage.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 90))
        contentView.addConstraint(NSLayoutConstraint(item: tdlImage, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: -10))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}