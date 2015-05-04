import Foundation
import UIKit

class Tag: NSObject, NSCoding {
    var name: String = ""
    var color: UIColor = UIColor.lightGrayColor()
    var enabled: Bool?
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