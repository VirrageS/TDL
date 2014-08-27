import UIKit

var menuItems = [String]()
var tags = [Tag]()
var listSections: [String] = []
var sectionItems = [[Task]]()
var isOpenTodayTaskCell = [[Bool]]()
var open = [[Bool]]()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        
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

        let leftMenu: UIViewController? = MenuViewController()
        let slideNavigation: SlideNavigationController = SlideNavigationController()
        slideNavigation.sharedInstance().menu = leftMenu!
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = UINavigationController(rootViewController: MenuViewController())
        window.makeKeyAndVisible()
        return true
    }
}
