import Foundation
import UIKit

class Task: NSObject, NSCoding {
    var name: String = ""
    var completed: Bool = false
    var dueDate: NSDate?
    var priority: Int = 1
    var tag: Tag?
    
    init(name: String, completed: Bool, dueDate: NSDate?, priority: Int, tag: Tag?) {
        self.name = name
        self.completed = completed
        self.dueDate = dueDate
        self.priority = priority
        
        if tag != nil {
            tag!.tasks++
            self.tag = tag!
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeBool(self.completed, forKey: "completed")
        aCoder.encodeObject(self.dueDate, forKey: "dueDate")
        aCoder.encodeInteger(self.priority, forKey: "priority")
        aCoder.encodeObject(self.tag, forKey: "tag")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.completed = aDecoder.decodeBoolForKey("completed")
        self.dueDate = aDecoder.decodeObjectForKey("dueDate") as? NSDate
        self.priority = aDecoder.decodeIntegerForKey("priority")
        self.tag = aDecoder.decodeObjectForKey("tag") as? Tag
    }
}