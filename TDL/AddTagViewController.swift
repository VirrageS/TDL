import UIKit

class AddTagViewController: UIViewController, UITableViewDelegate, UITextViewDelegate, SlideNavigationControllerDelegate {
    var textView: UITextView!
    var deleteButtonLabel: UIButton!
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Add Tag"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor() // fixes push animation
        
        textView = UITextView(frame: CGRectMake(30, 100, 200, 30))
        textView.delegate = self
        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha: 1).CGColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.editable = true
        textView.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
        textView.scrollRangeToVisible(NSMakeRange(textView.text.utf16Count, 0))
        textView.scrollsToTop = true
        //        textView.placeholder = "Message"
        view.addSubview(textView)
        
        deleteButtonLabel = UIButton.buttonWithType(UIButtonType.System) as UIButton
        deleteButtonLabel.layer.cornerRadius = 5.0
        deleteButtonLabel.setTitle("Delete", forState: UIControlState.Normal)
        deleteButtonLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        deleteButtonLabel.frame = CGRectMake(240, 103, 60, 25)
        deleteButtonLabel.backgroundColor = UIColor.redColor()
        deleteButtonLabel.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        view.addSubview(deleteButtonLabel)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //    override func canBecomeFirstResponder() -> Bool {
    //        return true
    //    }
    //
    //    override func viewDidLayoutSubviews()  {
    //        super.viewDidLayoutSubviews()
    ////
    //        if (textView.text != nil) {
    //            textViewDidChange(textView)
    //            textView.becomeFirstResponder()
    //        }
    //    }
    //
    //    func textViewDidChange(textView: UITextView!) {
    ////        updateTextViewHeight()
    ////        sendButton.enabled = textView.hasText()
    //    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}