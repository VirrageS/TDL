import UIKit

let cellTextFontSize: CGFloat = 12

var listSections: [String] = []
var sectionItems = [[List]]()
var hiddenEditCell = [[Bool]]()

class ListViewController: UITableViewController {
    convenience override init() {
        self.init(style: .Grouped)
        title = "To Do List"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listSections = ["Today", "Tommorow", "WTF"]
        sectionItems = [
            [
                List(name: "Buy milk11", completed: false, completionDate: NSDate.date(), priority: 1),
                List(name: "Buy milk12", completed: false, completionDate: NSDate.date(), priority: 1)
            ],
            [
                List(name: "Buy milk21", completed: false, completionDate: NSDate.date(), priority: 1),
                List(name: "Buy milk22", completed: false, completionDate: NSDate.date(), priority: 1)
            ],
            [
                List(name: "Buy milk31", completed: false, completionDate: NSDate.date(), priority: 1),
                List(name: "Buy milk32", completed: false, completionDate: NSDate.date(), priority: 1),
                List(name: "Buy milk33", completed: false, completionDate: NSDate.date(), priority: 1),
                List(name: "Buy milk34", completed: false, completionDate: NSDate.date(), priority: 1)
            ]
        ]
        
        for section in 0...sectionItems.count-1 {
            hiddenEditCell.insert([Bool](), atIndex: section)
            for row in 0...sectionItems[section].count-1 {
                hiddenEditCell[section].insert(true, atIndex: row)
            }
        }

        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewCell:")
        navigationItem.rightBarButtonItem = addButtonItem
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.rowHeight = listCellHeight
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        
        tableView.registerClass(ListCell.self, forCellReuseIdentifier: NSStringFromClass(ListCell))
        tableView.registerClass(ListEditCell.self, forCellReuseIdentifier: NSStringFromClass(ListEditCell))
        //ad items from file
        //loadInitialData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return sectionItems.count as Int
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return listSections[section] as String
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count*2 as Int
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if indexPath.row%2 == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ListCell), forIndexPath: indexPath) as ListCell
            cell.configureWithList(sectionItems[indexPath.section][indexPath.row/2])
            return cell as ListCell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ListEditCell), forIndexPath: indexPath) as ListEditCell
            cell.setButtonsHidden(indexPath)
            return cell as ListEditCell
        }
    }

    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var tappedCell = tableView.cellForRowAtIndexPath(indexPath)
        if tappedCell is ListEditCell {
            return
        }

        if hiddenEditCell[indexPath.section][(indexPath.row/2)] {
            hiddenEditCell[indexPath.section][(indexPath.row/2)] = false

            var newIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
            tableView.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        } else {
            hiddenEditCell[indexPath.section][(indexPath.row/2)] = true
            
            var newIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
            tableView.reloadRowsAtIndexPaths([newIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
        }
    }
    
    override func tableView(tableView: UITableView!, willSelectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        // cannot select row if is edit cell
        if indexPath.row%2 != 0 {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView!, willDeselectRowAtIndexPath indexPath: NSIndexPath!) -> NSIndexPath! {
        // cannot deselect row if is edit cell
        if indexPath.row%2 != 0 {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        // row height for normal cell
        if indexPath.row%2 == 0 {
            return listCellHeight
        }
        
        // check if edit cell is hiddens
        if hiddenEditCell[indexPath.section][(indexPath.row/2)] {
            return 0
        }
        
        return listEditCellHeight
    }
    
    func addNewCell(sender: AnyObject) {
        let addItemViewController = AddItemViewController()
        navigationController.pushViewController(addItemViewController, animated: true)
    }
    
    func openEditController(indexPath: NSIndexPath) {
        let editItemViewController: EditItemViewController = EditItemViewController(indexPath: indexPath)
        self.navigationController.pushViewController(editItemViewController, animated: true)
    }
    /*
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let newIndexPath = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
            
            tableView.beginUpdates()
                sectionItems[indexPath.section].removeAtIndex(indexPath.row/2)

                for i in 0...sectionItems[indexPath.section].count-1 {
                    hiddenEditCell[indexPath.section][i] = hiddenEditCell[indexPath.section][i+1]
                }
                hiddenEditCell[indexPath.section][sectionItems[indexPath.section].count] = false
            
                tableView.deleteRowsAtIndexPaths([indexPath, newIndexPath], withRowAnimation: UITableViewRowAnimation.Left)
            tableView.endUpdates()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    func updateData() {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
    let finalPath = documentsDirectory.stringByAppendingPathComponent("tdl.plist") as String
    NSKeyedArchiver.archiveRootObject(self.listItems, toFile: finalPath)
    }
    
    func loadInitialData() {
    let finalPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingPathComponent("tdl.plist") as String
    if NSFileManager.defaultManager().fileExistsAtPath(finalPath) {
    listItems = NSKeyedUnarchiver.unarchiveObjectWithFile(finalPath) as NSMutableArray
    }
    }
    */
    
    /*override func tableView(tableView: UITableView!, viewForHeaderInSection section: Int) -> UIView! {
    let label: UILabel = UILabel()
    label.frame = CGRectMake(0, 0, 320, 30)
    label.backgroundColor = UIColor.lightGrayColor()
    label.font = UIFont.boldSystemFontOfSize(18)
    label.text = listSections[section]
    
    let headerView: UIView = UIView()
    headerView.addSubview(label)
    return headerView
    }*/
}