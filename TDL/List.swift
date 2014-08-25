import Foundation

class List {
    var name: String = ""
    var completed: Bool = false
    var completionDate: NSDate
    var priority: Int = 1
    var openedEditCell: Bool = false
    
    
    init(name: String, completed: Bool, completionDate: NSDate, priority: Int) {
        self.name = name
        self.completed = completed
        self.completionDate = completionDate
        self.priority = priority
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeBool(self.completed, forKey: "completed")
        encoder.encodeObject(self.completionDate, forKey: "completionDate")
        encoder.encodeInteger(self.priority, forKey: "priority")
    }
    
    func initWithCoder(decoder: NSCoder) -> AnyObject {
        self.name = decoder.decodeObjectForKey("name") as String
        self.completed = decoder.decodeBoolForKey("completed")
        self.completionDate = decoder.decodeObjectForKey("completionDate") as NSDate
        self.priority = decoder.decodeIntegerForKey("priority")
        
        return self;
    }
}