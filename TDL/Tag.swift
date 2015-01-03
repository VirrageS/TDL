import Foundation
import UIKit

class Tag {
    let name: String = ""
    let color: UIColor = UIColor.lightGrayColor()
    let enabled: Bool?
    var tasks: Int = 0
    
    init(name: String, color: UIColor, enabled: Bool?) {
        self.color = color
        self.name = name
        self.enabled = enabled
    }
}