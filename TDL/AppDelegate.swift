import UIKit

var namesForSections: [(day: String, desc: String)] = []

var allTags = [Tag]()
var allTasks = [Task]()
var allFilters = [String]()
var tasksForNext7Days = [[Task]]()

var menuItems = [String]()
var priorityColors = [UIColor]()

let maxDateTextCharacters = 21 // Maximum characters in date box
let maxCharacters = 25 // Maximum characters in task name

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Loading allTasks and allTags
        loadInitialData()
        
        // Name for rows in left menu
        menuItems = [
            "Today",
            "Next 7 Days",
            "Tags",
            "Filters"
        ]
        
        // Colors which priority have
        priorityColors = [
            UIColor(red: 183/255, green: 73/255, blue: 50/255, alpha: 1.0),
            UIColor(red: 61/255, green: 99/255, blue: 163/255, alpha: 1.0),
            UIColor(red: 145/255, green: 196/255, blue: 250/255, alpha: 1.0),
            UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        ]

        // Names for sections in TaskViewController (Today, Tomorrow, ...)
        let day: NSTimeInterval = 60*60*24
        for i in 0...6 {
            var newDay: NSTimeInterval = day * NSTimeInterval(i)
            namesForSections.append(formatDate(NSDate(timeIntervalSinceNow: newDay)))
        }
        
        // Names for filters aviable
        allFilters = [
            "Priority 1",
            "Priority 2",
            "Priority 3",
            "Priority 4",
            "View all",
            "No due date"
        ]

        // Initing left menu
        let menuController = MenuViewController()
        let slideNavigation = SlideNavigationController()
        slideNavigation.sharedInstance().menu = menuController
 
        // Initing main menu (today tasks)
        let mainController = TodayTaskViewController()
        slideNavigation.sharedInstance()._delegate = mainController
        slideNavigation.pushViewController(mainController, animated: true)
        slideNavigation.setMenuRevealAnimator(SlideNavigationControllerAnimatorSlide())
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = UIColor.whiteColor()
        window!.rootViewController = slideNavigation
        window!.makeKeyAndVisible()
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        // Saving all data when application will terminate
        saveAllData()
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

    func saveAllData() {
        var documentDirectories: NSArray = []
        var documentDirectory: String = ""
        var path: String = ""
        
        documentDirectories = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        documentDirectory = documentDirectories.objectAtIndex(0) as! String
        path = documentDirectory.stringByAppendingPathComponent("allTasks.archive")
        if NSKeyedArchiver.archiveRootObject(allTasks, toFile: path) {
            // println("Success writing [allTasks] to file!")
        } else {
            println("Unable to write [allTasks] to file!")
        }
        
        path = documentDirectory.stringByAppendingPathComponent("allTags.archive")
        if NSKeyedArchiver.archiveRootObject(allTags, toFile: path) {
            // println("Success writing [allTags] to file!")
        } else {
            println("Unable to write [allTags] to file!")
        }
    }
    
    func loadInitialData() {
        var documentDirectories: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray
        var documentDirectory: String = documentDirectories.objectAtIndex(0) as! String
        var path: String = ""
        
        // Loading allTasks
        var tasks = [Task]()
        path = documentDirectory.stringByAppendingPathComponent("allTasks.archive")
        if let dataToRetrieve = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Task] {
            tasks = dataToRetrieve as [Task]
        }
        allTasks = tasks
        
        // Loading allTags
        var tags = [Tag]()
        path = documentDirectory.stringByAppendingPathComponent("allTags.archive")
        if let dataToRetrieve = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [Tag] {
            tags = dataToRetrieve as [Tag]
        }
        
        if tags.count == 0 { // if there is no tags we must add one
            allTags.append(Tag(name: "None", color: UIColor.clearColor(), enabled: false))
            allTags = allTags + tags
        } else { // if there is one or more we are sure that "none" tag is in there
            allTags = tags
        }
    }
}
