import Foundation
import UIKit

class Tag {
    var name: String = ""
    var color: UIColor = UIColor.lightGrayColor()
    var enabled: Bool?
    var tasks: Int = 0
    
    init(name: String, color: UIColor, enabled: Bool?) {
        self.color = color
        self.name = name
        self.enabled = enabled
    }
    
    func encodeWithCoder(encoder: NSCoder) {
        encoder.encodeObject(self.name, forKey: "name")
        encoder.encodeObject(self.color, forKey: "color")
        encoder.encodeBool(self.enabled!, forKey: "enabled")
        encoder.encodeInteger(self.tasks, forKey: "tasks")
    }
    
    func initWithCoder(decoder: NSCoder) -> AnyObject {
        self.name = decoder.decodeObjectForKey("name") as String
        self.color = decoder.decodeObjectForKey("color") as UIColor
        self.enabled = decoder.decodeBoolForKey("enabled") as Bool
        self.tasks = decoder.decodeIntegerForKey("tasks") as Int
        
        return self;
    }
}