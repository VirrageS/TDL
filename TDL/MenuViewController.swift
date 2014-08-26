import UIKit

var menuItems = [String]()
var tags = [Tag]()
var listSections: [String] = []
var sectionItems = [[Task]]()
var isOpenTodayTaskCell = [[Bool]]()
var open = [[Bool]]()

class MenuViewController: UITableViewController {
    let slideOutAnimationEnabled: Bool = true
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "MENU"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        menuItems = [
            "Today",
            "Next 7 Days",
            "Tags"
        ]
        
        tags = [
            Tag(name: "Home", color: UIColor.greenColor()),
            Tag(name: "School", color: UIColor.grayColor()),
            Tag(name: "Work", color: UIColor.redColor())
        ]
        
        listSections = ["Today", "Tommorow", "WTF"]
        sectionItems = [
            [
                Task(name: "Buy milk11", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[2]),
                Task(name: "Buy milk12", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[0])
            ],
            [
                Task(name: "Buy milk21", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[0]),
                Task(name: "Buy milk22", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[1])
            ],
            [
                Task(name: "Buy milk31", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[0]),
                Task(name: "Buy milk32", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[1]),
                Task(name: "Buy milk33", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[2]),
                Task(name: "Buy milk34", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[1])
            ]
        ]
        
        for section in 0...sectionItems.count-1 {
            open.insert([Bool](), atIndex: section)
            isOpenTodayTaskCell.insert([Bool](), atIndex: section)
            for row in 0...sectionItems[section].count-1 {
                open[section].insert(false, atIndex: row)
                isOpenTodayTaskCell[section].insert(false, atIndex: row)
            }
        }

        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.lightGrayColor()
        tableView.registerClass(MenuCell.self, forCellReuseIdentifier: NSStringFromClass(MenuCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MenuCell), forIndexPath: indexPath) as MenuCell
        cell.configure(menuItems[indexPath.row])
        return cell as MenuCell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var controller: UIViewController
        switch(indexPath.row) {
        case 0:
            controller = TodayTaskViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        case 1:
            controller = TaskViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        case 2:
            controller = TagViewController()
            navigationController.pushViewController(controller, animated: true)
            break
        default:
            break
        }

//        SlideNavigationController.sharedInstance()(popToRootAndSwitchToViewController: controller, withSlideOutAnimation:self.slideOutAnimationEnabled, andCompletion:nil) // TODO
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return menuCellHeight
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
