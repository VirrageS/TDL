import UIKit

class AddTagViewController: UIViewController, UITextFieldDelegate, SlideNavigationControllerDelegate {
    var circleView: UILabel!
    var circleButton: UIButton!
    var textView: UITextField!
    var colorPickerView: UIView!
    var transparentView: UIButton!

    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Add tag"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor() // fixes push animation

        let addButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "addTag:")
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.rightBarButtonItem!.enabled = false
        
        circleView = UILabel(frame: CGRect(x: 7.5, y: 5, width: 20, height: 20))
        circleView.layer.borderColor = UIColor(red: 162/255, green: 186/255, blue: 102/255, alpha: 1.0).CGColor
        circleView.layer.borderWidth = 10
        circleView.layer.cornerRadius = 10

        circleButton = UIButton(frame: CGRectZero)
        circleButton.addTarget(self, action: "openCollectionView:", forControlEvents: UIControlEvents.TouchUpInside)
        circleButton.backgroundColor = UIColor.whiteColor()
        circleButton.addSubview(circleView)
        addCustomButtonSubviews(circleButton, "")

        textView = UITextField(frame: CGRectZero)
        addCustomTextFieldSubview(textView)
        textView.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        textView.placeholder = "Tag"
        textView.delegate = self
        textView.becomeFirstResponder()

        colorPickerView = UIView(frame: CGRectZero)
        colorPickerView.backgroundColor = UIColor.whiteColor()
        colorPickerView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).CGColor
        colorPickerView.layer.borderWidth = 0.5
        colorPickerView.layer.cornerRadius = 2
        colorPickerView.hidden = true
        
        transparentView = UIButton(frame: view.frame)
        transparentView.addTarget(self, action: "closeCollectionView:", forControlEvents: UIControlEvents.TouchUpInside)
        transparentView.enabled = false
        transparentView.addSubview(colorPickerView)
        
        view.addSubview(circleButton)
        view.addSubview(textView)
        view.addSubview(transparentView)

        collectionView()
        
        circleButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: circleButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: circleButton, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: circleButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 55))
        view.addConstraint(NSLayoutConstraint(item: circleButton, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 130))
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 65))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 100))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 130))
        
        colorPickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: colorPickerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 55))
        view.addConstraint(NSLayoutConstraint(item: colorPickerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 250))
        view.addConstraint(NSLayoutConstraint(item: colorPickerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -55))
        view.addConstraint(NSLayoutConstraint(item: colorPickerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 330))
    }
    
    func addTag(sender: AnyObject) {
        let newTag: Tag = Tag(name: textView.text, color: UIColor(CGColor: circleView.layer.borderColor)!, enabled: true)
        
        // check if there is a tag with this name
        var ok: Bool = true
        for i in 0...allTags.count - 1 {
            if allTags[i].name.lowercaseString == newTag.name.lowercaseString {
                ok = false
            }
        }
        
        // if everything is okay add tag otherwise show alert
        if ok {
            allTags.append(newTag)
        } else {
            var alert = UIAlertView()
            alert.title = "Error"
            alert.message = "You cannot add new tag with the same name as other tag has"
            alert.addButtonWithTitle("Back")
            alert.show()
        }
        
        var slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation.popViewControllerAnimated(true)
    }
    
    func openCollectionView(sender: AnyObject) {
        colorPickerView.hidden = false
        transparentView.enabled = true
        transparentView.backgroundColor = UIColor(red: 104/255, green: 103/255, blue: 105/255, alpha: 0.75)
        
        circleButton.enabled = false
        textView.enabled = false
        navigationItem.rightBarButtonItem!.enabled = false
    }
    
    func closeCollectionView(sender: AnyObject) {
        colorPickerView.hidden = true
        transparentView.enabled = false
        transparentView.backgroundColor = UIColor.clearColor()
        
        circleButton.enabled = true
        textView.enabled = true
        navigationItem.rightBarButtonItem!.enabled = textView.hasText()
    }
    
    func collectionView() {
        var colors = [[UIColor]]()
        colors = [
            [
                UIColor(red: 162/255, green: 186/255, blue: 102/255, alpha: 1.0),
                UIColor(red: 227/255, green: 205/255, blue: 123/255, alpha: 1.0),
                UIColor(red: 166/255, green: 184/255, blue: 214/255, alpha: 1.0),
                UIColor(red: 120/255, green: 178/255, blue: 235/255, alpha: 1.0),
                UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
            ],
            [
                UIColor(red: 199/255, green: 179/255, blue: 215/255, alpha: 1.0),
                UIColor(red: 216/255, green: 152/255, blue: 119/255, alpha: 1.0),
                UIColor(red: 191/255, green: 175/255, blue: 158/255, alpha: 1.0),
                UIColor(red: 226/255, green: 179/255, blue: 65/255, alpha: 1.0),
                UIColor(red: 146/255, green: 190/255, blue: 195/255, alpha: 1.0)
            ]
        ]
        
        for i in 0...1 {
            for j in 0...4 {
                var collectionCellCircleView: UILabel!
                var collectionCellCircleButton: UIButton!
            
                collectionCellCircleView = UILabel(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
                collectionCellCircleView.layer.borderColor = colors[i][j].CGColor
                collectionCellCircleView.layer.borderWidth = 10
                collectionCellCircleView.layer.cornerRadius = 10

                collectionCellCircleButton = UIButton(frame: CGRect(x: j*40+10, y: i*40+5, width: 30, height: 30))//CGRectZero)
                collectionCellCircleButton.addTarget(self, action: "changeColor:", forControlEvents: UIControlEvents.TouchUpInside)
                collectionCellCircleButton.backgroundColor = UIColor.whiteColor()
                
                collectionCellCircleButton.addSubview(collectionCellCircleView)
            
//                collectionCellCircleButton.setTranslatesAutoresizingMaskIntoConstraints(false)
//                colorPickerView.addConstraint(NSLayoutConstraint(item: collectionCellCircleButton, attribute: .Left, relatedBy: .Equal, toItem: colorPickerView, attribute: .Left, multiplier: 1, constant: CGFloat(j*40+10)))
//                colorPickerView.addConstraint(NSLayoutConstraint(item: collectionCellCircleButton, attribute: .Top, relatedBy: .Equal, toItem: colorPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40+5)))
//                colorPickerView.addConstraint(NSLayoutConstraint(item: collectionCellCircleButton, attribute: .Right, relatedBy: .Equal, toItem: colorPickerView, attribute: .Left, multiplier: 1, constant: CGFloat(j*40+10+30)))
//                colorPickerView.addConstraint(NSLayoutConstraint(item: collectionCellCircleButton, attribute: .Bottom, relatedBy: .Equal, toItem: colorPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40+5+30)))
            
                colorPickerView.addSubview(collectionCellCircleButton)
            }
        }
    }
    
    func changeColor(sender: UIButton) {
        closeCollectionView(sender)
        circleView.layer.borderColor = sender.subviews[0].layer.borderColor
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidChanged(textField: UITextField!) {
        if count(textField.text) > maxCharacters {
            textField.text = textField.text.substringToIndex(advance(textField.text.startIndex, maxCharacters))
        }
        
        navigationItem.rightBarButtonItem!.enabled = textView.hasText()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}