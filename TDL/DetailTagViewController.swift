import UIKit

var isOpenDetailTagCell = [Bool]()

class DetailTagViewController: UITableViewController, SlideNavigationControllerDelegate {
    var detailTagTasks = [Task]()
    var tag: Tag?
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(tag: Tag) {
        super.init(nibName: nil, bundle: nil)
        title = tag.name

        self.tag = tag
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        detailTagTasks.removeAll(keepCapacity: false)
        for i in 0...allTasks.count-1 {
            if allTasks[i].count > 0 {
                for j in 0...allTasks[i].count-1 {
                    if allTasks[i][j].tag === self.tag! {
                        detailTagTasks.append(allTasks[i][j])
                    }
                }
            }
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag?.enabled != false {
            let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "openEditTagViewController:")
            navigationItem.rightBarButtonItem = addButtonItem
        }
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(NoTaskCell.self, forCellReuseIdentifier: NSStringFromClass(NoTaskCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailTagTasks.count > 0 ? detailTagTasks.count : 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (detailTagTasks.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
            cell.configureCell(detailTagTasks[indexPath.row])
            return cell as TaskCell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(NoTaskCell), forIndexPath: indexPath) as NoTaskCell
        tableView.scrollEnabled = false
        return cell as NoTaskCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Row height for closed cell
        if (detailTagTasks.count > 0) {
            return taskCellHeight
        }
        
        return noTaskCellHeight
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell: AnyObject? = tableView.cellForRowAtIndexPath(indexPath)
        if cell is NoTaskCell {
            return false
        }
        
        return true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openEditTagViewController(sender: AnyObject) {
        let editTagViewController = EditTagViewController(tag: tag!)
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = editTagViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openAddTaskController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(editTagViewController, animated: true)
    }
}