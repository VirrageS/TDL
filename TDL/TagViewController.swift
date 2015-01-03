import UIKit

class TagViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return true
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Tags"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var toolbar = UIToolbar(frame: CGRectZero)//(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
//        //toolbar.backgroundColor = UIColor.blackColor()
//        var items: NSMutableArray = NSMutableArray()
//        items.addObject(UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editTag:"))
//        items.addObject(UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: "addTag:"))
//        toolbar.setItems(items, animated: true)

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTagController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
//        view.addSubview(toolbar)
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.clearColor() // transparent separator
        tableView.registerClass(TagCell.self, forCellReuseIdentifier: NSStringFromClass(TagCell))
        
//        toolbar.setTranslatesAutoresizingMaskIntoConstraints(false)
//        view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
//        view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 200))
//        view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        //view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: -40))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTags.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TagCell), forIndexPath: indexPath) as TagCell
        cell.configure(indexPath.row)
        return cell as TagCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tagCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detailTagViewController = DetailTagViewController(tag: allTags[indexPath.row])
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = detailTagViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openDetailTagViewController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(detailTagViewController, animated: true)
    }

    func openAddTagController(sender: AnyObject) {
        let addTagViewController = AddTagViewController()
    
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = addTagViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openAddTagController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(addTagViewController, animated: true)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}