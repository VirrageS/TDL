import UIKit

class EditTagViewController: UIViewController {
    let path: NSIndexPath
    //var textView: UITextView = "Hello"
    
    init(indexPath: NSIndexPath) {
        self.path = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "Edit Tag"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let whiteColor = UIColor.whiteColor()
        view.backgroundColor = whiteColor // fixes push animation
        
        
        //        textView = UITextView.alloc()
        //        textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
        //        textView.delegate = self
        //        textView.font = UIFont.systemFontOfSize(messageFontSize)
        //        textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
        //        textView.layer.borderWidth = 0.5
        //        textView.layer.cornerRadius = 5
        //        //        textView.placeholder = "Message"
        //        textView.scrollsToTop = false
        //        textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
        //        view.addSubview(textView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}