import UIKit

class FilterViewController: UITableViewController, SlideNavigationControllerDelegate {
    func shouldDisplayMenu() -> Bool {
        return true
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Filters"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddFilterController:")
//        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.clearColor() // transparent separator
        tableView.registerClass(FilterCell.self, forCellReuseIdentifier: NSStringFromClass(FilterCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allFilters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FilterCell), forIndexPath: indexPath) as FilterCell
        cell.configure(indexPath.row)
        return cell as FilterCell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return filterCellHeight
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let detailFilterViewController = DetailFilterViewController(text: allFilters[indexPath.row])
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = detailFilterViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openDetailTagViewController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(detailFilterViewController, animated: true)
    }
    
    // 
    func openAddFilterController(sender: AnyObject) {
//        let addTagViewController = AddTagViewController()
//        
//        let slideNavigation = SlideNavigationController().sharedInstance()
//        slideNavigation._delegate = addTagViewController
//        
//        // Check if navigationController is nil
//        if navigationController == nil {
//            println("openAddTagController - navigationController is nil")
//            return
//        }
//        
//        navigationController!.pushViewController(addTagViewController, animated: true)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}