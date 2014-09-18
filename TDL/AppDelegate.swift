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

var priorityColors = [UIColor]()

enum UpdateType {
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
            "Tags"
        ]
        
        tags = [
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

        // Names for sections (Today, Tommorow...)
        let day: NSTimeInterval = 60*60*24
        for i in 0...6 {
            var newDay: NSTimeInterval = day * NSTimeInterval(i)
            listSections.append(formatDate(NSDate(timeIntervalSinceNow: newDay)))
        }
        
        sectionItems = [
            [
                Task(name: "Mow the lawn", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[2]),
                Task(name: "Check mail", completed: false, completionDate: NSDate.date(), priority: 0, tag: tags[0])
            ],
            [
                Task(name: "Write an email to Jennifer", completed: false, completionDate: NSDate.date(), priority: 2, tag: tags[0]),
                Task(name: "Buy milk22", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[1])
            ],
            [
                Task(name: "Buy milk31", completed: false, completionDate: NSDate.date(), priority: 1, tag: tags[0]),
                Task(name: "Buy milk32", completed: false, completionDate: NSDate.date(), priority: 3, tag: tags[1]),
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
    
    func formatDate(date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        
        if calendar.isDateInToday(date) { // Today
            return "Today"
        } else if calendar.isDateInTomorrow(date) { // Tommorow
            return "Tommorow"
        }
        
        // Full name of day
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
