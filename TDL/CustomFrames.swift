import UIKit

func addCustomTextFieldSubview(textField: UITextField) {
    // Input text padding
    textField.leftView = UIView(frame: CGRectMake(0, 0, 5, 1))
    textField.leftViewMode = UITextFieldViewMode.Always
    
    textField.font = UIFont.systemFontOfSize(13) // font size

    // Defining
    var textFieldBottomBorder = UIView(frame: CGRectZero)
    textFieldBottomBorder.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    var textFieldLeftBorder = UIView(frame: CGRectZero)
    textFieldLeftBorder.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    var textFieldRightBorder = UIView(frame: CGRectZero)
    textFieldRightBorder.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)

    // Subviews
    textField.addSubview(textFieldBottomBorder)
    textField.addSubview(textFieldLeftBorder)
    textField.addSubview(textFieldRightBorder)
    
    // Constraints
    textFieldBottomBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
    textField.addConstraint(NSLayoutConstraint(item: textFieldBottomBorder, attribute: .Left, relatedBy: .Equal, toItem: textField, attribute: .Left, multiplier: 1, constant: 1))
    textField.addConstraint(NSLayoutConstraint(item: textFieldBottomBorder, attribute: .Top, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: -1))
    textField.addConstraint(NSLayoutConstraint(item: textFieldBottomBorder, attribute: .Right, relatedBy: .Equal, toItem: textField, attribute: .Right, multiplier: 1, constant: 0))
    textField.addConstraint(NSLayoutConstraint(item: textFieldBottomBorder, attribute: .Bottom, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: 0))
    
    textFieldLeftBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
    textField.addConstraint(NSLayoutConstraint(item: textFieldLeftBorder, attribute: .Left, relatedBy: .Equal, toItem: textField, attribute: .Left, multiplier: 1, constant: 0))
    textField.addConstraint(NSLayoutConstraint(item: textFieldLeftBorder, attribute: .Top, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: -3))
    textField.addConstraint(NSLayoutConstraint(item: textFieldLeftBorder, attribute: .Right, relatedBy: .Equal, toItem: textField, attribute: .Left, multiplier: 1, constant: 1))
    textField.addConstraint(NSLayoutConstraint(item: textFieldLeftBorder, attribute: .Bottom, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: 0))
    
    textFieldRightBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
    textField.addConstraint(NSLayoutConstraint(item: textFieldRightBorder, attribute: .Left, relatedBy: .Equal, toItem: textField, attribute: .Right, multiplier: 1, constant: -1))
    textField.addConstraint(NSLayoutConstraint(item: textFieldRightBorder, attribute: .Top, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: -3))
    textField.addConstraint(NSLayoutConstraint(item: textFieldRightBorder, attribute: .Right, relatedBy: .Equal, toItem: textField, attribute: .Right, multiplier: 1, constant: 0))
    textField.addConstraint(NSLayoutConstraint(item: textFieldRightBorder, attribute: .Bottom, relatedBy: .Equal, toItem: textField, attribute: .Bottom, multiplier: 1, constant: 0))
}

func addCustomButtonSubviews(button: UIButton, labelText: String?) {
    var buttonTextLabel: UILabel?
    if labelText != nil {
        buttonTextLabel = UILabel(frame: CGRectZero)
        buttonTextLabel!.font = UIFont.systemFontOfSize(13)
        buttonTextLabel!.text = labelText!
        buttonTextLabel!.textAlignment = NSTextAlignment.Left
        buttonTextLabel!.textColor = UIColor.blackColor()
    }
    
    var buttonBottomBorder = UIView(frame: CGRectZero)
    buttonBottomBorder.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1.0)
    
    var buttonExtendImage = UIImageView(image: UIImage(named: "extend-image"))
    
    if labelText != nil {
        button.addSubview(buttonTextLabel!)
    }
    button.addSubview(buttonBottomBorder)
    button.addSubview(buttonExtendImage)
    
    if labelText != nil {
        buttonTextLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.addConstraint(NSLayoutConstraint(item: buttonTextLabel!, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Left, multiplier: 1, constant: 5))
        button.addConstraint(NSLayoutConstraint(item: buttonTextLabel!, attribute: .Top, relatedBy: .Equal, toItem: button, attribute: .Top, multiplier: 1, constant: 8))
        button.addConstraint(NSLayoutConstraint(item: buttonTextLabel!, attribute: .Right, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: -30))
        button.addConstraint(NSLayoutConstraint(item: buttonTextLabel!, attribute: .Bottom, relatedBy: .Equal, toItem: button, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    
    buttonBottomBorder.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.addConstraint(NSLayoutConstraint(item: buttonBottomBorder, attribute: .Left, relatedBy: .Equal, toItem: button, attribute: .Left, multiplier: 1, constant: 0))
    button.addConstraint(NSLayoutConstraint(item: buttonBottomBorder, attribute: .Top, relatedBy: .Equal, toItem: button, attribute: .Bottom, multiplier: 1, constant: -1))
    button.addConstraint(NSLayoutConstraint(item: buttonBottomBorder, attribute: .Right, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 0))
    button.addConstraint(NSLayoutConstraint(item: buttonBottomBorder, attribute: .Bottom, relatedBy: .Equal, toItem: button, attribute: .Bottom, multiplier: 1, constant: 0))
    
    buttonExtendImage.setTranslatesAutoresizingMaskIntoConstraints(false)
    button.addConstraint(NSLayoutConstraint(item: buttonExtendImage, attribute: .Right, relatedBy: .Equal, toItem: button, attribute: .Right, multiplier: 1, constant: 0))
    button.addConstraint(NSLayoutConstraint(item: buttonExtendImage, attribute: .Bottom, relatedBy: .Equal, toItem: button, attribute: .Bottom, multiplier: 1, constant: 0))
}
