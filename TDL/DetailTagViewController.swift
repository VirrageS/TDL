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
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTaskController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailTagTasks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
        cell.configureCell(detailTagTasks[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Row height for closed cell
        return taskCellHeight
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func openAddTaskController(sender: AnyObject) {
        let addTaskViewController = AddTaskViewController()
        
        let slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation._delegate = addTaskViewController
        
        // Check if navigationController is nil
        if navigationController == nil {
            println("openAddTaskController - navigationController is nil")
            return
        }
        
        navigationController!.pushViewController(addTaskViewController, animated: true)
    }
}