import UIKit

var namesForSections: [(day: String, desc: String)] = []

var allTags = [Tag]()
var allTasks = [Task]()
var allFilters = [String]()
var tasksForNext7Days = [[Task]]()

var menuItems = [String]()
var priorityColors = [UIColor]()

enum UpdateType { // #ToDelete - not sure if has purpose
    case Today
    case All
    case None
}

let maxDateTextCharacters = 21
let maxCharacters = 25

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        loadInitialData()
        
        menuItems = [
            "Today",
            "Next 7 Days",
            "Tags",
            "Filters"
        ]
        
        allTags = [
            Tag(name: "None", color: UIColor.clearColor(), enabled: false),
            Tag(name: "Home", color: UIColor.greenColor(), enabled: true),
            Tag(name: "School", color: UIColor.grayColor(), enabled: true),
            Tag(name: "Work", color: UIColor.redColor(), enabled: true)
        ]
        
        priorityColors = [
            UIColor(red: 183/255, green: 73/255, blue: 50/255, alpha: 1.0),
            UIColor(red: 61/255, green: 99/255, blue: 163/255, alpha: 1.0),
            UIColor(red: 145/255, green: 196/255, blue: 250/255, alpha: 1.0),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        ]

        // Names for sections (Today, Tomorrow, ...)
        let day: NSTimeInterval = 60*60*24
        for i in 0...6 {
            var newDay: NSTimeInterval = day * NSTimeInterval(i)
            namesForSections.append(formatDate(NSDate(timeIntervalSinceNow: newDay)))
        }
        
        allTasks = [
            Task(name: "Buy new keyboard", completed: false, dueDate: NSDate(timeIntervalSinceNow: -3*24*60*60), priority: 1, tag: allTags[2]),
            Task(name: "Study to math exam", completed: false, dueDate: NSDate(timeIntervalSinceNow: -1*24*60*60), priority: 1, tag: allTags[2]),
            Task(name: "Mow the lawn", completed: false, dueDate: NSDate(), priority: 1, tag: allTags[2]),
            Task(name: "Check mail", completed: false, dueDate: NSDate(), priority: 0, tag: allTags[0]),
            Task(name: "Write an email to Jennifer", completed: false, dueDate: NSDate(timeIntervalSinceNow: 1*24*60*60), priority: 2, tag: allTags[0]),
            Task(name: "Buy milk22", completed: false, dueDate: NSDate(timeIntervalSinceNow: 1*24*60*60), priority: 1, tag: allTags[1]),
            Task(name: "Buy milk31", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 1, tag: allTags[0]),
            Task(name: "Buy milk32", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 3, tag: allTags[1]),
            Task(name: "Buy milk33", completed: false, dueDate: NSDate(timeIntervalSinceNow: 2*24*60*60), priority: 1, tag: allTags[2]),
            Task(name: "Buy milk34", completed: false, dueDate: NSDate(timeIntervalSinceNow: 3*24*60*60), priority: 1, tag: allTags[1]),
            Task(name: "Buy milk34", completed: false, dueDate: NSDate(timeIntervalSinceNow: 5*24*60*60), priority: 1, tag: allTags[1])
        ]
        
        allFilters = [
            "Priority 1",
            "Priority 2",
            "Priority 3",
            "Priority 4",
            "View all",
            "No due date"
        ]

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
        } else if calendar.isDateInTomorrow(date) { // Tomorrow
            dateFormatter.dateFormat = "ccc LLL dd"
            return (day: "Tomorrow ", desc: dateFormatter.stringFromDate(date))
        }
    
        // Full name of day
        dateFormatter.dateFormat = "cccc"
        var _day: String = dateFormatter.stringFromDate(date)
        dateFormatter.dateFormat = "LLL dd"
        var _desc: String = dateFormatter.stringFromDate(date)
        return (day: _day, desc: _desc)
    }
    
    func applicationWillTerminate(application: UIApplication) {
        updateData()
    }
    
    func updateData() {
//        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        let finalPath = documentsDirectory.stringByAppendingPathComponent("todayTasks.plist") as String
//        NSKeyedArchiver.archiveRootObject(todayTasks, toFile: finalPath)
//        
//
        
        
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        var path = paths.stringByAppendingPathComponent("todayTaskses.plist")
//        var fileManager = NSFileManager.defaultManager()
//        if (!(fileManager.fileExistsAtPath(path)))
//        {
//            var bundle : NSString? = NSBundle.mainBundle().pathForResource("todayTaskses", ofType: "plist")
//            if bundle != nil {
//                fileManager.copyItemAtPath(bundle!, toPath: path, error: nil)
//            } else {
//                println("BIG FUCKING ERROR")
//            }
//        }
//        
//        var data: NSMutableDictionary = NSMutableDictionary(object: allTags, forKey: "todayTaskes")
//        data.writeToFile(path, atomically: true)
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(allTags)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "tags")
        
        loadInitialData()
    }
    
    func loadInitialData() {
//        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
//        var path = paths.stringByAppendingPathComponent("todayTaskses.plist")
//        let save = NSMutableDictionary(contentsOfFile: path)
//        
//        print(save)
        
        if let data = NSUserDefaults.standardUserDefaults().objectForKey("tags") as? NSData {
            allTags = NSKeyedUnarchiver.unarchiveObjectWithData(data) as [Tag]
        }
    }
}
