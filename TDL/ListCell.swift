import UIKit

let listCellHeight: CGFloat = 35

class ListCell: UITableViewCell {
    let nameTextLabel: UILabel
    var hasOpenedEditCell: Bool = true
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String) {
        nameTextLabel = UILabel(frame: CGRectZero)
        nameTextLabel.backgroundColor = UIColor.whiteColor()
        nameTextLabel.font = UIFont.systemFontOfSize(cellTextFontSize)
        nameTextLabel.numberOfLines = 1
        nameTextLabel.textAlignment = NSTextAlignment.Left;
        nameTextLabel.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameTextLabel)
        
        nameTextLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Left, relatedBy: .Equal, toItem: contentView, attribute: .Left, multiplier: 1, constant: 30))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Top, relatedBy: .Equal, toItem: contentView, attribute: .Top, multiplier: 1, constant: 10))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Right, relatedBy: .Equal, toItem: contentView, attribute: .Right, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: nameTextLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithList(list: List) {
        nameTextLabel.text = list.name
    }
}