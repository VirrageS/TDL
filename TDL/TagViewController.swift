import UIKit

class TagViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return true
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Tags"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTagController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.clearColor() // transparent separator
        tableView.registerClass(TagCell.self, forCellReuseIdentifier: NSStringFromClass(TagCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TagCell), forIndexPath: indexPath) as TagCell
        cell.configure(indexPath.row)
        return cell as TagCell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return tagCellHeight
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detailTagViewController = DetailTagViewController(tag: tags[indexPath.row])
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = detailTagViewController
        
        navigationController.pushViewController(detailTagViewController, animated: true)
    }

    func openAddTagController(sender: AnyObject) {
        let addTagViewController = AddTagViewController()
    
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = addTagViewController
        
        navigationController.pushViewController(addTagViewController, animated: true)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}