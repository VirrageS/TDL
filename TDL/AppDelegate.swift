import UIKit


var listSections = [String]()
var sectionItems = [[Task]]()
var tags = [Tag]()
var open = [[Bool]]()

var isOpenTodayTaskCell = [[Bool]]()
var isOpenNext7DaysTaskCell = [[Bool]]() // for "open"

var namesForNext7DaysSections = [String]() // for "listSection"

var allTags = [Tag]() // for "tags"
var allTasks = [Task]() // for "sectionItems" but also must be created new list
var tasksForNext7Days = [[Task]]()

var menuItems = [String]() // for now it is good

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

        let day: NSTimeInterval = 60*60*24
        for i in 0...6 {
            var newDay: NSTimeInterval = day * NSTimeInterval(i)
            listSections.insert(formatDate(NSDate(timeIntervalSinceNow: newDay)), atIndex: i)
        }
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
            ],
            [],[],[],[],[],[]
        ]
        
        for section in 0...sectionItems.count-1 {
            open.insert([Bool](), atIndex: section)
            isOpenTodayTaskCell.insert([Bool](), atIndex: section)
            if sectionItems[section].count > 0 {
                for row in 0...sectionItems[section].count-1 {
                    open[section].insert(false, atIndex: row)
                    isOpenTodayTaskCell[section].insert(false, atIndex: row)
                }
            } else {
                open[section].insert(false, atIndex: 0)
            }
        }

        let slideNavigation = SlideNavigationController()
        slideNavigation.sharedInstance().menu = MenuViewController()
        
        let mainController = TodayTaskViewController()
        slideNavigation.sharedInstance()._delegate = mainController
        slideNavigation.pushViewController(mainController, animated: true)
        slideNavigation.setMenuRevealAnimator(SlideNavigationControllerAnimatorSlide())
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.whiteColor()
        window.rootViewController = slideNavigation
        window.makeKeyAndVisible()
        return true
    }
    
    func formatDate(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        
        if calendar.isDateInToday(date) { // today
            return "Today"
        } else if calendar.isDateInTomorrow(date) { // tommorow
            return "Tommorow"
        }
        
        dateFormatter.dateFormat = "cccc"
        return dateFormatter.stringFromDate(date)
    }
    
    /*
    
    
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
}
