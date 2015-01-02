import UIKit

var isOpenTodayTaskCell = [[Bool]]()
var isOpenNext7DaysTaskCell = [[Bool]]()

var namesForSections: [(day: String, desc: String)] = []

var allTags = [Tag]()
var allTasks = [[Task]]() // #Change - task must be inserted and got by NSDate not by section
var allFilters = [String]()
var tasksForNext7Days = [[Task]]()

var menuItems = [String]()
var priorityColors = [UIColor]()

enum UpdateType { // #Delete - not sure if has purpose
    case Today
    case All
    case None
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        menuItems = [
            "Today",
            "Next 7 Days",
            "Tags",
            "Filters"
        ]
        
        allTags = [
            Tag(name: "Home", color: UIColor.greenColor()),
            Tag(name: "School", color: UIColor.grayColor()),
            Tag(name: "Work", color: UIColor.redColor())
        ]
        
        priorityColors = [
            UIColor(red: 183/255, green: 73/255, blue: 50/255, alpha: 1.0),
            UIColor(red: 61/255, green: 99/255, blue: 163/255, alpha: 1.0),
            UIColor(red: 145/255, green: 196/255, blue: 250/255, alpha: 1.0),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        ]

        // Names for sections (Today, Tommorow, ...)
        let day: NSTimeInterval = 60*60*24
        for i in 0...6 {
            var newDay: NSTimeInterval = day * NSTimeInterval(i)
            namesForSections.append(formatDate(NSDate(timeIntervalSinceNow: newDay)))
        }
        
        allTasks = [
            [
                Task(name: "Mow the lawn", completed: false, dueDate: NSDate(), priority: 1, tag: allTags[2]),
                Task(name: "Check mail", completed: false, dueDate: NSDate(), priority: 0, tag: allTags[0])
            ],
            [
                Task(name: "Write an email to Jennifer", completed: false, dueDate: NSDate(timeIntervalSinceNow: 1*24*60*60), priority: 2, tag: allTags[0]),
                Task(name: "Buy milk22", completed: false, dueDate: NSDate(timeIntervalSinceNow: 1*24*60*60), priority: 1, tag: allTags[1])
            ],
            [
                Task(name: "Buy milk31", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 1, tag: allTags[0]),
                Task(name: "Buy milk32", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 3, tag: allTags[1]),
                Task(name: "Buy milk33", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 1, tag: allTags[2])
            ],
            [
                Task(name: "Buy milk34", completed: false, dueDate: NSDate(timeIntervalSinceNow: 3*24*60*60), priority: 1, tag: allTags[1])
            ],[],[
                Task(name: "Buy milk34", completed: false, dueDate: NSDate(timeIntervalSinceNow: 5*24*60*60), priority: 1, tag: allTags[1])
            ],[],[],[]
        ]
        
        allFilters = [
            "Priority 1",
            "Priority 2",
            "Priority 3",
            "Priority 4",
            "View all",
            "No due date"
        ]

        for section in 0...allTasks.count-1 {
            isOpenNext7DaysTaskCell.insert([Bool](), atIndex: section)
            isOpenTodayTaskCell.insert([Bool](), atIndex: section)
            
            if allTasks[section].count > 0 {
                for row in 0...allTasks[section].count-1 {
                    isOpenNext7DaysTaskCell[section].insert(false, atIndex: row)
                    isOpenTodayTaskCell[section].insert(false, atIndex: row)
                }
            } else {
                isOpenNext7DaysTaskCell[section].insert(false, atIndex: 0)
            }
        }

        let menuController = MenuViewController()
        let slideNavigation = SlideNavigationController()
        slideNavigation.sharedInstance().menu = menuController
 
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
    
    func formatDate(date: NSDate) -> (day: String, desc: String) {
        let calendar = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        
        if calendar.isDateInToday(date) { // Today
            dateFormatter.dateFormat = "ccc LLL dd"
            return (day: "Today ", desc: dateFormatter.stringFromDate(date))
        } else if calendar.isDateInTomorrow(date) { // Tommorow
            dateFormatter.dateFormat = "ccc LLL dd"
            return (day: "Tommorow ", desc: dateFormatter.stringFromDate(date))
        }
    
        // Full name of day
        dateFormatter.dateFormat = "cccc"
        var _day: String = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "LLL dd"
        var _desc: String = dateFormatter.stringFromDate(date)
        return (day: _day, desc: _desc)
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
