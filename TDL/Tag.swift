import Foundation
import UIKit

class Tag: NSObject, NSCoding {
    /// Name for the tage
    var name: String = ""
    /// Color circle of the tag
    var color: UIColor = UIColor.lightGrayColor()
    /// Determines if the tag can be used or no
    var enabled: Bool?
    /// Task counter
    var tasks: Int = 0
    
    init(name: String, color: UIColor, enabled: Bool?) {
        self.color = color
        self.name = name
        self.enabled = enabled
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.color, forKey: "color")
        aCoder.encodeBool(self.enabled!, forKey: "enabled")
        aCoder.encodeInteger(self.tasks, forKey: "tasks")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("name") as! String
        self.color = aDecoder.decodeObjectForKey("color") as! UIColor
        self.enabled = aDecoder.decodeBoolForKey("enabled") as Bool
        self.tasks = aDecoder.decodeIntegerForKey("tasks") as Int
    }
}