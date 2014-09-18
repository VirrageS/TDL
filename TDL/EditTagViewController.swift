import UIKit

class EditTagViewController: UIViewController, SlideNavigationControllerDelegate {
    let path: NSIndexPath

    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(indexPath: NSIndexPath) {
        self.path = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "Edit Tag"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor() // fixes push animation
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}