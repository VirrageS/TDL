import UIKit

class AddTaskViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, SlideNavigationControllerDelegate {
    var textView: UITextField!
    var tagPickerButton: UIButton!
    var dateTextView: UITextField!
    var separatorLine: UIView!
    var calendarButton: UIButton!
    var priorityPickerButton: UIButton!
    var tagPickerView: UIView!
    var datePickerView: UIView!
    var priorityPickerView: UIView!
    var transparentView: UIButton!
    var datePicker: UIDatePicker!
    
    var priorityPickerOpen: Bool = false
    var datePickerOpen: Bool = false
    var tagPickerOpen: Bool = false
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Add task"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor() // fixes push animation
        
        // Navigation Button
        let addButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: "addTask:")
        navigationItem.rightBarButtonItem = addButtonItem
        navigationItem.rightBarButtonItem!.enabled = false

        // Normal view
        textView = UITextField(frame: CGRectZero)
        addCustomTextFieldSubview(textView)
        textView.addTarget(self, action: "textFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        textView.placeholder = "Task"
        textView.delegate = self
        textView.becomeFirstResponder()
        
        tagPickerButton = UIButton(frame: CGRectZero)
        tagPickerButton.addTarget(self, action: "showTagPicker:", forControlEvents: UIControlEvents.TouchUpInside)
        tagPickerButton.backgroundColor = UIColor.whiteColor()
        if allTags.count > 0 {
            addCustomButtonSubviews(tagPickerButton, nil)
        } else {
            // #Change to something like placeholder or come up with new idea
            // addCustomButtonSubviews(tagPickerButton, nil)
        }

        // Date view
        dateTextView = UITextField(frame: CGRectZero)
        dateTextView.rightView = UIView(frame: CGRectMake(0, 0, 40, 1)) // to make calendarButton working everytime
        dateTextView.rightViewMode = UITextFieldViewMode.Always // to make calendarButton working everytime
        addCustomTextFieldSubview(dateTextView) // for separatorLine and extendButton
        dateTextView.addTarget(self, action: "dateFieldDidChanged:", forControlEvents: UIControlEvents.EditingChanged)
        dateTextView.placeholder = "No due date"
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
        addCustomButtonSubviews(priorityPickerButton, "Priority 4")
        
        // Transparent view
        tagPickerView = UIView(frame: CGRectZero)
        tagPickerView.backgroundColor = UIColor.whiteColor()
        tagPickerView.hidden = true
        addTagPickerViewSubviews()
        
        datePickerView = UIView(frame: CGRectZero)
        datePickerView.backgroundColor = UIColor.whiteColor()
        datePickerView.hidden = true
        addDatePickerViewSubviews()
        
        priorityPickerView = UIView(frame: CGRectZero)
        priorityPickerView.backgroundColor = UIColor.whiteColor()
        priorityPickerView.hidden = true
        addPriorityPickerViewSubviews()
        
        
        var doneButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        doneButton.frame = CGRectZero
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.addTarget(self, action: "closePickerView:", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.backgroundColor = UIColor.whiteColor()
        
        datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.addTarget(self, action: "datePickerChanged:", forControlEvents: UIControlEvents.ValueChanged)
        datePicker.backgroundColor = UIColor.whiteColor()
        datePicker.hidden = true
        datePicker.addSubview(doneButton)
        
        transparentView = UIButton(frame: view.frame)
        transparentView.addTarget(self, action: "closePickerView:", forControlEvents: UIControlEvents.TouchUpInside)
        transparentView.enabled = false
        transparentView.addSubview(tagPickerView)
        transparentView.addSubview(datePickerView)
        transparentView.addSubview(priorityPickerView)
        transparentView.addSubview(datePicker)

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
        
        datePickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: datePickerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 35))
        view.addConstraint(NSLayoutConstraint(item: datePickerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 200))
        view.addConstraint(NSLayoutConstraint(item: datePickerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -35))
        view.addConstraint(NSLayoutConstraint(item: datePickerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 365))
        
        priorityPickerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 55))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 250))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -55))
        view.addConstraint(NSLayoutConstraint(item: priorityPickerView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 250+CGFloat(40*priorityColors.count)))
        
        datePicker.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 300))
        view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: datePicker, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 485))
        
        doneButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Top, relatedBy: .Equal, toItem: datePicker, attribute: .Bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .Bottom, relatedBy: .Equal, toItem: datePicker, attribute: .Bottom, multiplier: 1, constant: 40))
    }
    
    func addTask(sender: AnyObject) {
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
            if tag.name == tagLabel!.text && tag.enabled != false {
                taskTag = tag
                break
            }
        }
        
        // Get date
        var dateFormats = ["dd/MM/yyyy", "dd.MM.yyyy", "MM/dd/yyyy", "MM.dd.yyyy", "dd MMM yyyy HH:mm", "dd MMM yyyy", "MMM dd yyyy", "HH:mm dd MMM yyyy", "HH:mm MMM dd yyyy"]
        var nonTrivialDateFormats = [
            ["today"]: NSDate(),
            ["tomorrow", "in 1 day", "in one day", "+1 day", "next day"]: NSDate(timeIntervalSinceNow: NSTimeInterval(60*60*24)),
            ["in 1 week", "in one week", "next week", "+1 week"]: NSDate(timeIntervalSinceNow: NSTimeInterval(7*60*60*24)),
            ["in 1 month", "in one month", "next month", "+1 month"]: NSDate(timeIntervalSinceNow: NSTimeInterval(30*60*60*24)),
            ["none", "no due date"]: NSDate(timeIntervalSince1970: NSTimeInterval(0))
        ]
        
        var dueDate: NSDate?
        if dateTextView.hasText() {
            var ok: Bool = false
            for (dates, time) in nonTrivialDateFormats {
                for date in dates as [String] {
                    if dateTextView.text.lowercaseString == (date as String) && !ok {
                        dueDate = time as? NSDate
                        ok = true
                    }
                }
            }
            
            if ok {
                if (dueDate!.isEqualToDateIgnoringTime((NSDate(timeIntervalSince1970: NSTimeInterval(0)) as NSDate))) { // #Change - some bugs there
                    dueDate = nil
                }
            }
            
            if !ok {
                var dateFormatter = NSDateFormatter()
                
                for _dateFormat in dateFormats {
                    dateFormatter.dateFormat = _dateFormat
                    dueDate = dateFormatter.dateFromString(dateTextView.text)
                    
                    if dueDate != nil {
                        break
                    }
                }
                
                if dueDate != nil {
                    println("timeIntervalSinceNow: \(dueDate!.timeIntervalSinceNow)")
                    
                    if dueDate!.timeIntervalSinceNow < 0 {
                        println("Date is outdated")
                    } else {
                        println("Date is after 7 days")
                    }
                }
            }
        }
        
        println("Date is set to: \(dueDate)")
        
        // Create task
        let newTask: Task = Task(name: textView.text, completed: false, dueDate: dueDate, priority: taskPrority-1, tag: taskTag)
        
        // Insert new task
        allTasks.append(newTask)

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
        calendarButton.enabled = false
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
        calendarButton.enabled = false
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
        datePickerView.hidden = false
        
        transparentView.enabled = true
        transparentView.backgroundColor = UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 0.75)
        
        // Disable button
        tagPickerButton.enabled = false
        calendarButton.enabled = false
        priorityPickerButton.enabled = false
        
        // Disable text fields
        textView.enabled = false
        dateTextView.enabled = false
        
        // Disable done button
        navigationItem.rightBarButtonItem!.enabled = false
        // Set open for true
        datePickerOpen = true
    }
    
    func closePickerView(sender: AnyObject) {
        // Hide date picker
        datePicker.hidden = true
        
        // Hide transparent view
        transparentView.enabled = false
        transparentView.backgroundColor = UIColor.clearColor()
        
        // Enable buttons
        tagPickerButton.enabled = true
        calendarButton.enabled = true
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
        } else if datePickerOpen {
            datePickerView.hidden = true
            datePickerOpen = false
        }
    }
    
    func updateTag(sender: UIButton) {
        var mainLabel: UILabel = tagPickerButton.subviews[0] as UILabel
        var senderLabel: UILabel = sender.subviews[0] as UILabel
        mainLabel.text = senderLabel.text
        
        if allTags[sender.tag].enabled != false { // if is enabled
            mainLabel.textColor = UIColor.blackColor()
        } else {
            mainLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0)
        }
        
        closePickerView(sender)
    }
    
    func addTagPickerViewSubviews() {
        var tagPickerViewLabel: UILabel!
        var tagPickerViewCircle: UILabel!
        var tagPickerViewButton: UIButton!
        
        for i in 0...allTags.count-1 {
            tagPickerViewLabel = UILabel(frame: CGRectZero)
            tagPickerViewLabel.font = UIFont.systemFontOfSize(13)
            tagPickerViewLabel.textColor = ((allTags[i].enabled != false) ? UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0) : UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0))
            tagPickerViewLabel.text = allTags[i].name
            
            tagPickerViewCircle = UILabel(frame: CGRect(x: 10, y: 15, width: 10, height: 10))
            tagPickerViewCircle.layer.borderWidth = 5
            tagPickerViewCircle.layer.cornerRadius = 5
            tagPickerViewCircle.layer.borderColor = allTags[i].color.CGColor
            
            tagPickerViewButton = UIButton(frame: CGRectZero)
            tagPickerViewButton.addTarget(self, action: "updateTag:", forControlEvents: UIControlEvents.TouchUpInside)
            tagPickerViewButton.tag = i
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
    
    func updateDate(sender: UIButton) {
        var senderLabel: UILabel = sender.subviews[0] as UILabel

        if senderLabel.text?.lowercaseString == "pick date" {
            datePicker.hidden = false
            datePickerView.hidden = true
        } else {
            dateTextView.text = senderLabel.text
            closePickerView(sender)
        }
    }

    func datePickerChanged(datePicker:UIDatePicker) {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        dateTextView.text = strDate
    }
    
    func addDatePickerViewSubviews() {
        var datePickerIconView: UIImageView!
        var datePickerViewLabel: UILabel!
        var datePickerViewButton: UIButton!
        
        let datePickOptions = [
            [
                (name: "Today", image: "today-icon"),
                (name: "Tomorrow", image: "tomorrow-icon"),
                (name: "+1 week", image: "week-icon")
            ],
            [
                (name: "+1 month", image: "month-icon"),
                (name: "Pick date", image: "pick-date-icon"),
                (name: "No due date", image: "no-due-date-icon")
            ]
        ]
        
        for i in 0...datePickOptions.count-1 {
            for j in 0...datePickOptions[i].count-1 {
                datePickerIconView = UIImageView(frame: CGRectZero)
                datePickerIconView.image = UIImage(named: datePickOptions[i][j].image)
                
                datePickerViewLabel = UILabel(frame: CGRectZero)
                datePickerViewLabel.font = UIFont.systemFontOfSize(13)
                datePickerViewLabel.textAlignment = NSTextAlignment.Center
                datePickerViewLabel.textColor = UIColor(red: 90/255, green: 90/255, blue: 90/255, alpha: 1.0)
                datePickerViewLabel.text = datePickOptions[i][j].name
                
                datePickerViewButton = UIButton(frame: CGRectZero)
                datePickerViewButton.addTarget(self, action: "updateDate:", forControlEvents: UIControlEvents.TouchUpInside)
                datePickerViewButton.backgroundColor = UIColor.clearColor()
                datePickerViewButton.addSubview(datePickerViewLabel)
                datePickerViewButton.addSubview(datePickerIconView)

                datePickerView.addSubview(datePickerViewButton)
                
                datePickerViewButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerViewButton, attribute: .Left, relatedBy: .Equal, toItem: datePickerView, attribute: .Left, multiplier: 1, constant: CGFloat(j*80+5)))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerViewButton, attribute: .Top, relatedBy: .Equal, toItem: datePickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*75+10)))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerViewButton, attribute: .Right, relatedBy: .Equal, toItem: datePickerView, attribute: .Left, multiplier: 1, constant: CGFloat(j*80+85)))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerViewButton, attribute: .Bottom, relatedBy: .Equal, toItem: datePickerView, attribute: .Top, multiplier: 1, constant: CGFloat(i*75)+65+10))
                
                datePickerIconView.setTranslatesAutoresizingMaskIntoConstraints(false)
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerIconView, attribute: .Left, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Left, multiplier: 1, constant: 25))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerIconView, attribute: .Top, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Top, multiplier: 1, constant: 8))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerIconView, attribute: .Right, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Left, multiplier: 1, constant: 25+32))
                datePickerView.addConstraint(NSLayoutConstraint(item: datePickerIconView, attribute: .Bottom, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Top, multiplier: 1, constant: 8+32))
                
                datePickerViewLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
                datePickerViewButton.addConstraint(NSLayoutConstraint(item: datePickerViewLabel, attribute: .Left, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Left, multiplier: 1, constant: 0))
                datePickerViewButton.addConstraint(NSLayoutConstraint(item: datePickerViewLabel, attribute: .Top, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Bottom, multiplier: 1, constant: -20))
                datePickerViewButton.addConstraint(NSLayoutConstraint(item: datePickerViewLabel, attribute: .Right, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Right, multiplier: 1, constant: 0))
                datePickerViewButton.addConstraint(NSLayoutConstraint(item: datePickerViewLabel, attribute: .Bottom, relatedBy: .Equal, toItem: datePickerViewButton, attribute: .Bottom, multiplier: 1, constant: 0))
            }
        }
    }
    
    func updatePriority(sender: UIButton) {
        var mainLabel: UILabel = priorityPickerButton.subviews[0] as UILabel
        var senderLabel: UILabel = sender.subviews[0] as UILabel
        mainLabel.text = senderLabel.text
        if mainLabel.text != "None" {
            mainLabel.textColor = UIColor.blackColor()
        } else {
            mainLabel.textColor = UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0)
        }
        
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
        if textField.text.utf16Count > maxDateTextCharacters {
            textField.text = textField.text.substringToIndex(advance(textField.text.startIndex, maxDateTextCharacters))
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