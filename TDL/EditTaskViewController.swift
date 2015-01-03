import UIKit

class EditTaskViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, SlideNavigationControllerDelegate {
    let path: NSIndexPath
    var textView: UITextField!
    var tagPickerButton: UIButton!
    var dateTextView: UITextField!
    var separatorLine: UIView!
    var calendarButton: UIButton!
    var priorityPickerButton: UIButton!
    var tagPickerView: UIView!
    var priorityPickerView: UIView!
    var transparentView: UIButton!
    
    var priorityPickerOpen: Bool = false
    var tagPickerOpen: Bool = false
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(indexPath: NSIndexPath) {
        self.path = indexPath
        super.init(nibName: nil, bundle: nil)
        title = "Edit Task"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.whiteColor() // fixes push animation
        
        // Navigation Button
        let addButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "completeEditingTask:")
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.rightBarButtonItem!.enabled = true
        
        // Normal view
        textView = UITextField(frame: CGRectZero)
        addCustomTextFieldSubview(textView)
        textView.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        textView.text = allTasks[path.section][path.row].name
        textView.delegate = self
        textView.becomeFirstResponder()
        
        tagPickerButton = UIButton(frame: CGRectZero)
        tagPickerButton.addTarget(self, action: "showTagPicker:", forControlEvents: UIControlEvents.TouchUpInside)
        tagPickerButton.backgroundColor = UIColor.whiteColor()
        if allTasks[path.section][path.row].tag != nil {
            addCustomButtonSubviews(tagPickerButton, allTasks[path.section][path.row].tag!.name)
        }
        
        // Date view
        dateTextView = UITextField(frame: CGRectZero)
        dateTextView.rightView = UIView(frame: CGRectMake(0, 0, 40, 1)) // to make calendarButton working everytime
        dateTextView.rightViewMode = UITextFieldViewMode.Always // to make calendarButton working everytime
        addCustomTextFieldSubview(dateTextView) // for separatorLine and extendButton
        dateTextView.addTarget(self, action: "dateFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        if allTasks[path.section][path.row].dueDate != nil {
            var dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
            dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")

            dateTextView.text = dateFormatter.stringFromDate(allTasks[path.section][path.row].dueDate!)
        } else {
             dateTextView.placeholder = "No due date"
        }
        dateTextView.delegate = self
        
        separatorLine = UIView(frame: CGRectZero) // to separate dateTextView and calendarButton
        separatorLine.backgroundColor = UIColor(red: 190/255, green: 190/255, blue: 190/255, alpha: 1.0)
        
        calendarButton = UIButton(frame: CGRectZero)
        calendarButton.setBackgroundImage(UIImage(named: "calendar-icon"), forState: UIControlState.Normal)
        calendarButton.addTarget(self, action: "showDatePicker:", forControlEvents: UIControlEvents.TouchUpInside)
        calendarButton.backgroundColor = UIColor.clearColor()
        
        // Priority view
        priorityPickerButton = UIButton(frame: CGRectZero)
        priorityPickerButton.addTarget(self, action: "showPriorityPicker:", forControlEvents: UIControlEvents.TouchUpInside)
        priorityPickerButton.backgroundColor = UIColor.whiteColor()
        addCustomButtonSubviews(priorityPickerButton, "Priority " + String(allTasks[path.section][path.row].priority + 1))
        
        // Transparent view
        tagPickerView = UIView(frame: CGRectZero)
        tagPickerView.backgroundColor = UIColor.whiteColor()
        tagPickerView.hidden = true
        addTagPickerViewSubviews()
        
        priorityPickerView = UIView(frame: CGRectZero)
        priorityPickerView.backgroundColor = UIColor.whiteColor()
        priorityPickerView.hidden = true
        addPriorityPickerViewSubviews()
        
        transparentView = UIButton(frame: view.frame)
        transparentView.addTarget(self, action: "closePickerView:", forControlEvents: UIControlEvents.TouchUpInside)
        transparentView.enabled = false
        transparentView.addSubview(tagPickerView)
        transparentView.addSubview(priorityPickerView)
        
        // View subviews
        view.addSubview(textView)
        view.addSubview(tagPickerButton)
        view.addSubview(dateTextView)
        view.addSubview(priorityPickerButton)
        view.addSubview(transparentView)
        
        // More subviews
        dateTextView.addSubview(calendarButton)
        dateTextView.addSubview(separatorLine)
        
        // Constraints
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 80))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 110))
        
        tagPickerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: tagPickerButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: tagPickerButton, attribute: .Top, relatedBy: .Equal, toItem: textView, attribute: .Bottom, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: tagPickerButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: tagPickerButton, attribute: .Bottom, relatedBy: .Equal, toItem: textView, attribute: .Bottom, multiplier: 1, constant: 40))
        
        dateTextView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .Top, relatedBy: .Equal, toItem: tagPickerButton, attribute: .Bottom, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: dateTextView, attribute: .Bottom, relatedBy: .Equal, toItem: tagPickerButton, attribute: .Bottom, multiplier: 1, constant: 40))
        
        separatorLine.setTranslatesAutoresizingMaskIntoConstraints(false)
        dateTextView.addConstraint(NSLayoutConstraint(item: separatorLine, attribute: .Left, relatedBy: .Equal, toItem: dateTextView, attribute: .Right, multiplier: 1, constant: -36))
        dateTextView.addConstraint(NSLayoutConstraint(item: separatorLine, attribute: .Top, relatedBy: .Equal, toItem: dateTextView, attribute: .Top, multiplier: 1, constant: 4))
        dateTextView.addConstraint(NSLayoutConstraint(item: separatorLine, attribute: .Right, relatedBy: .Equal, toItem: dateTextView, attribute: .Right, multiplier: 1, constant: -35))
        dateTextView.addConstraint(NSLayoutConstraint(item: separatorLine, attribute: .Bottom, relatedBy: .Equal, toItem: dateTextView, attribute: .Bottom, multiplier: 1, constant: -4))
        
        calendarButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        dateTextView.addConstraint(NSLayoutConstraint(item: calendarButton, attribute: .Left, relatedBy: .Equal, toItem: dateTextView, attribute: .Right, multiplier: 1, constant: -27))
        dateTextView.addConstraint(NSLayoutConstraint(item: calendarButton, attribute: .Top, relatedBy: .Equal, toItem: dateTextView, attribute: .Top, multiplier: 1, constant: 5))
        dateTextView.addConstraint(NSLayoutConstraint(item: calendarButton, attribute: .Right, relatedBy: .Equal, toItem: dateTextView, attribute: .Right, multiplier: 1, constant: -7))
        dateTextView.addConstraint(NSLayoutConstraint(item: calendarButton, attribute: .Bottom, relatedBy: .Equal, toItem: dateTextView, attribute: .Bottom, multiplier: 1, constant: -5))
        
        priorityPickerButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: priorityPickerButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 30))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerButton, attribute: .Top, relatedBy: .Equal, toItem: dateTextView, attribute: .Bottom, multiplier: 1, constant: 10))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -30))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerButton, attribute: .Bottom, relatedBy: .Equal, toItem: dateTextView, attribute: .Bottom, multiplier: 1, constant: 40))
        
        tagPickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: tagPickerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 55))
        view.addConstraint(NSLayoutConstraint(item: tagPickerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 200))
        view.addConstraint(NSLayoutConstraint(item: tagPickerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -55))
        view.addConstraint(NSLayoutConstraint(item: tagPickerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 200+CGFloat(40*allTags.count)))
        
        priorityPickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 55))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 250))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -55))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 250+CGFloat(40*priorityColors.count)))
    }
    
    func completeEditingTask(sender: AnyObject) {
        // Get priority
        var priorityLabel: UILabel? = priorityPickerButton.subviews[0] as? UILabel
        if priorityLabel == nil {
            println("Cannot get priority label. It is nil")
            return
        } else if priorityLabel!.text == nil {
            println("Cannot get priority label text. It is nil")
            return
        }
        
        var priorityLabelText: String = String(priorityLabel!.text![advance(priorityLabel!.text!.startIndex, countElements(priorityLabel!.text!)-1)])
        var taskPrority: Int = priorityLabelText.toInt()!
        
        // Get tag
        var tagLabel: UILabel? = tagPickerButton.subviews[0] as? UILabel
        if tagLabel == nil {
            println("Cannot get tag label. It is nil")
            return
        } else if tagLabel!.text == nil {
            println("Cannot get tag label text. It is nil")
            return
        }
        
        var taskTag: Tag?
        for tag in allTags {
            if tag.name == tagLabel!.text {
                taskTag = tag
                break
            }
        }
        
        // Get date
        var dateFormats = ["dd/MM/yyyy", "dd.MM.yyyy", "MM/dd/yyyy", "MM.dd.yyyy", "dd MMM yyyy"]
        var date: NSDate?
        var section: Int?
        if dateTextView.hasText() {
            if dateTextView.text.lowercaseString == "today" {
                section = 0
                date = NSDate()
            } else if dateTextView.text.lowercaseString == "tommorow" {
                section = 1
                date = NSDate(timeIntervalSinceNow: NSTimeInterval(60*60*24))
            } else if dateTextView.text.lowercaseString == "in 1 week" {
                section = 6
                date = NSDate(timeIntervalSinceNow: NSTimeInterval(7*60*60*24))
            } else if dateTextView.text.lowercaseString == "in 1 month" {
                // #Change in 1 month
                // section = nil
                date = NSDate(timeIntervalSinceNow: NSTimeInterval(30*60*60*24))
            } else {
                var dateFormatter = NSDateFormatter()
                
                for _dateFormat in dateFormats {
                    dateFormatter.dateFormat = _dateFormat
                    date = dateFormatter.dateFromString(dateTextView.text)
                    
                    if date != nil {
                        break
                    }
                }
                
                if date != nil {
                    println("timeIntervalSinceNow: \(date!.timeIntervalSinceNow)")
                    
                    if date!.timeIntervalSinceNow < 0 {
                        println("Date is outdated")
                        date = NSDate()
                    } else if date!.timeIntervalSinceNow <= NSTimeInterval(24*60*60*6) {
                        section = Int((date!.timeIntervalSinceNow)/60/60/24)+1
                    } else {
                        println("Date is after 7 days")
                    }
                }
            }
        }
        
        println("Date is set to: \(date)")
        
        // Create new task
        let newTask: Task = Task(name: textView.text, completed: false, dueDate: date, priority: taskPrority - 1, tag: taskTag)
        allTasks[path.section][path.row] = newTask // #Change - we dont change position even if due date has changed
        
        // Back to previous controller
        var slideNavigation = SlideNavigationController().sharedInstance()
        slideNavigation.popViewControllerAnimated(true)
    }
    
    func showTagPicker(sender: AnyObject) {
        // Show tag picker
        tagPickerView.hidden = false
        
        // Show transparent view with alpha
        transparentView.enabled = true
        transparentView.backgroundColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 0.75)
        
        // Disable button
        tagPickerButton.enabled = false
        priorityPickerButton.enabled = false
        
        // Disable text fields
        textView.enabled = false
        dateTextView.enabled = false
        
        // Disable done button
        navigationItem.rightBarButtonItem!.enabled = false
        // Set open for true
        tagPickerOpen = true
    }
    
    func showPriorityPicker(sender: AnyObject) {
        // Show priority picker
        priorityPickerView.hidden = false
        
        // Show transparent view with alpha
        transparentView.enabled = true
        transparentView.backgroundColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 0.75)
        
        // Disable button
        tagPickerButton.enabled = false
        priorityPickerButton.enabled = false
        
        // Disable text fields
        textView.enabled = false
        dateTextView.enabled = false
        
        // Disable done button
        navigationItem.rightBarButtonItem!.enabled = false
        // Set open for true
        priorityPickerOpen = true
    }
    
    func showDatePicker(sender: AnyObject) {
        println("showDatePicker called")
    }
    
    func closePickerView(sender: AnyObject) {
        // Hide transparent view
        transparentView.enabled = false
        transparentView.backgroundColor = UIColor.clearColor()
        
        // Enable buttons
        tagPickerButton.enabled = true
        priorityPickerButton.enabled = true
        
        // Enable text fields
        textView.enabled = true
        dateTextView.enabled = true
        
        // Update navigation button
        updateNavigationItem()
        
        // Update rest
        if priorityPickerOpen {
            priorityPickerView.hidden = true
            priorityPickerOpen = false
        } else if tagPickerOpen {
            tagPickerView.hidden = true
            tagPickerOpen = false
        }
    }
    
    func updatePriority(sender: UIButton) {
        var mainLabel: UILabel = priorityPickerButton.subviews[0] as UILabel
        var senderLabel: UILabel = sender.subviews[0] as UILabel
        mainLabel.text = senderLabel.text
        
        closePickerView(sender)
    }
    
    func addPriorityPickerViewSubviews() {
        var priorityPickerViewLabel: UILabel!
        var priorityPickerViewColor: UILabel!
        var priorityPickerViewButton: UIButton!
        
        for i in 0...3 {
            priorityPickerViewLabel = UILabel(frame: CGRectZero)
            priorityPickerViewLabel.font = UIFont.systemFontOfSize(13)
            priorityPickerViewLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0)
            priorityPickerViewLabel.text = "Priority \(i+1)"
            
            priorityPickerViewColor = UILabel(frame: CGRect(x: 0, y: 0, width: 3, height: 40))
            priorityPickerViewColor.backgroundColor = priorityColors[i]
            
            priorityPickerViewButton = UIButton(frame: CGRectZero)
            priorityPickerViewButton.addTarget(self, action: "updatePriority:", forControlEvents: UIControlEvents.TouchUpInside)
            priorityPickerViewButton.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
            priorityPickerViewButton.addSubview(priorityPickerViewLabel)
            priorityPickerViewButton.addSubview(priorityPickerViewColor)
            
            priorityPickerView.addSubview(priorityPickerViewButton)
            
            priorityPickerViewButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            priorityPickerView.addConstraint(NSLayoutConstraint(item: priorityPickerViewButton, attribute: .Left, relatedBy: .Equal, toItem: priorityPickerView, attribute: .Left, multiplier: 1, constant: 0))
            priorityPickerView.addConstraint(NSLayoutConstraint(item: priorityPickerViewButton, attribute: .Top, relatedBy: .Equal, toItem: priorityPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40)))
            priorityPickerView.addConstraint(NSLayoutConstraint(item: priorityPickerViewButton, attribute: .Right, relatedBy: .Equal, toItem: priorityPickerView, attribute: .Right, multiplier: 1, constant: 0))
            priorityPickerView.addConstraint(NSLayoutConstraint(item: priorityPickerViewButton, attribute: .Bottom, relatedBy: .Equal, toItem: priorityPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40)+40))
            
            priorityPickerViewLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            priorityPickerViewButton.addConstraint(NSLayoutConstraint(item: priorityPickerViewLabel, attribute: .Left, relatedBy: .Equal, toItem: priorityPickerViewButton, attribute: .Left, multiplier: 1, constant: 10))
            priorityPickerViewButton.addConstraint(NSLayoutConstraint(item: priorityPickerViewLabel, attribute: .Top, relatedBy: .Equal, toItem: priorityPickerViewButton, attribute: .Top, multiplier: 1, constant: 0))
            priorityPickerViewButton.addConstraint(NSLayoutConstraint(item: priorityPickerViewLabel, attribute: .Right, relatedBy: .Equal, toItem: priorityPickerViewButton, attribute: .Right, multiplier: 1, constant: 0))
            priorityPickerViewButton.addConstraint(NSLayoutConstraint(item: priorityPickerViewLabel, attribute: .Bottom, relatedBy: .Equal, toItem: priorityPickerViewButton, attribute: .Bottom, multiplier: 1, constant: 0))
        }
    }
    
    func updateTag(sender: UIButton) {
        var mainLabel: UILabel = tagPickerButton.subviews[0] as UILabel
        var senderLabel: UILabel = sender.subviews[0] as UILabel
        mainLabel.text = senderLabel.text
        
        closePickerView(sender)
    }
    
    func addTagPickerViewSubviews() {
        var tagPickerViewLabel: UILabel!
        var tagPickerViewCircle: UILabel!
        var tagPickerViewButton: UIButton!
        
        for i in 0...allTags.count-1 {
            tagPickerViewLabel = UILabel(frame: CGRectZero)
            tagPickerViewLabel.font = UIFont.systemFontOfSize(13)
            tagPickerViewLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0)
            tagPickerViewLabel.text = allTags[i].name
            
            tagPickerViewCircle = UILabel(frame: CGRect(x: 10, y: 15, width: 10, height: 10))
            tagPickerViewCircle.layer.borderWidth = 5
            tagPickerViewCircle.layer.cornerRadius = 5
            tagPickerViewCircle.layer.borderColor = allTags[i].color.CGColor
            
            tagPickerViewButton = UIButton(frame: CGRectZero)
            tagPickerViewButton.addTarget(self, action: "updateTag:", forControlEvents: UIControlEvents.TouchUpInside)
            tagPickerViewButton.backgroundColor = UIColor.whiteColor()
            tagPickerViewButton.addSubview(tagPickerViewLabel)
            tagPickerViewButton.addSubview(tagPickerViewCircle)
            
            tagPickerView.addSubview(tagPickerViewButton)
            
            tagPickerViewButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            tagPickerView.addConstraint(NSLayoutConstraint(item: tagPickerViewButton, attribute: .Left, relatedBy: .Equal, toItem: tagPickerView, attribute: .Left, multiplier: 1, constant: 0))
            tagPickerView.addConstraint(NSLayoutConstraint(item: tagPickerViewButton, attribute: .Top, relatedBy: .Equal, toItem: tagPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40)))
            tagPickerView.addConstraint(NSLayoutConstraint(item: tagPickerViewButton, attribute: .Right, relatedBy: .Equal, toItem: tagPickerView, attribute: .Right, multiplier: 1, constant: 0))
            tagPickerView.addConstraint(NSLayoutConstraint(item: tagPickerViewButton, attribute: .Bottom, relatedBy: .Equal, toItem: tagPickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*40)+40))
            
            tagPickerViewLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
            tagPickerViewButton.addConstraint(NSLayoutConstraint(item: tagPickerViewLabel, attribute: .Left, relatedBy: .Equal, toItem: tagPickerViewButton, attribute: .Left, multiplier: 1, constant: 30))
            tagPickerViewButton.addConstraint(NSLayoutConstraint(item: tagPickerViewLabel, attribute: .Top, relatedBy: .Equal, toItem: tagPickerViewButton, attribute: .Top, multiplier: 1, constant: 0))
            tagPickerViewButton.addConstraint(NSLayoutConstraint(item: tagPickerViewLabel, attribute: .Right, relatedBy: .Equal, toItem: tagPickerViewButton, attribute: .Right, multiplier: 1, constant: 0))
            tagPickerViewButton.addConstraint(NSLayoutConstraint(item: tagPickerViewLabel, attribute: .Bottom, relatedBy: .Equal, toItem: tagPickerViewButton, attribute: .Bottom, multiplier: 1, constant: 0))
        }
    }
    
    func updateNavigationItem() {
        navigationItem.rightBarButtonItem!.enabled = textView.hasText()// && dateTextView.hasText()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        
        if textView == textField {
            dateTextView.becomeFirstResponder()
        }
        
        return false
    }
    
    func textFieldDidChanged(textField: UITextField!) {
        if textField.text.utf16Count > maxCharacters {
            textField.text = textField.text.substringToIndex(advance(textField.text.startIndex, maxCharacters))
        }
        
        updateNavigationItem()
    }
    
    func dateFieldDidChanged(textField: UITextField!) {
        if textField.text.utf16Count > 21 {
            textField.text = textField.text.substringToIndex(advance(textField.text.startIndex, 21))
        }
        
        updateNavigationItem()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}