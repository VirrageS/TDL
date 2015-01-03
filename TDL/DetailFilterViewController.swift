import UIKit

class DetailFilterViewController: UITableViewController, SlideNavigationControllerDelegate {
    var detailFilterTasks = [Task]()
    var text: String?
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        title = text
        
        self.text = text
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        detailFilterTasks.removeAll(keepCapacity: false)

        switch (text! as String) {
            case "Priority 1":
                for i in 0...allTasks.count-1 {
                    if allTasks[i].priority == 0 {
                        detailFilterTasks.append(allTasks[i])
                    }
                }
            break
            
            case "Priority 2":
                for i in 0...allTasks.count-1 {
                    if allTasks[i].priority == 1 {
                        detailFilterTasks.append(allTasks[i])
                    }
                }
            break
            
            case "Priority 3":
                for i in 0...allTasks.count-1 {
                    if allTasks[i].priority == 2 {
                        detailFilterTasks.append(allTasks[i])
                    }
                }
            break
            
            case "Priority 4":
                for i in 0...allTasks.count-1 {
                    if allTasks[i].priority == 3 {
                        detailFilterTasks.append(allTasks[i])
                    }
                }
            break

            case "View all":
                detailFilterTasks = allTasks
            break

            case "No due date":
                for i in 0...allTasks.count-1 {
                    if allTasks[i].dueDate == nil {
                        detailFilterTasks.append(allTasks[i])
                    }
                }
            break
            
            default:
            break
        }

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        tableView.registerClass(TaskCell.self, forCellReuseIdentifier: NSStringFromClass(TaskCell))
        tableView.registerClass(NoTaskCell.self, forCellReuseIdentifier: NSStringFromClass(NoTaskCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailFilterTasks.count > 0 ? detailFilterTasks.count : 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (detailFilterTasks.count > 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TaskCell), forIndexPath: indexPath) as TaskCell
            cell.configureCell(detailFilterTasks[indexPath.row])
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
        if (detailFilterTasks.count > 0) {
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
}