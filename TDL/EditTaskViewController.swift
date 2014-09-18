import UIKit

class EditTaskViewController: UIViewController, UITableViewDelegate, UITextViewDelegate, SlideNavigationControllerDelegate {
    let path: NSIndexPath
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(indexPath: NSIndexPath) {
        self.path = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "Edit Task"
    }
    
    func slideNavigationControllerShouldDisplayLeftMenu() -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor() // fixes push animation

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}