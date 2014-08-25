import Foundation
import UIKit

class Tag {
    let name: String = ""
    let color: UIColor = UIColor.lightGrayColor()
    var tasks: Int = 0
    
    init(name: String, color: UIColor) {
        self.color = color
        self.name = name
    }
}