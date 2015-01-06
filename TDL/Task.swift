import Foundation
import UIKit

class Task: NSObject {
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
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeBool(self.completed, forKey: "completed")
        encoder.encodeObject(self.dueDate, forKey: "dueDate")
        encoder.encodeInteger(self.priority, forKey: "priority")
        encoder.encodeObject(self.tag, forKey: "tag")
    }
    
    func initWithCoder(decoder: NSCoder) -> AnyObject {
        self.name = decoder.decodeObjectForKey("name") as String
        self.completed = decoder.decodeBoolForKey("completed")
        self.dueDate = decoder.decodeObjectForKey("dueDate") as? NSDate
        self.priority = decoder.decodeIntegerForKey("priority")
        self.tag = decoder.decodeObjectForKey("tag") as? Tag
        
        return self;
    }
}