import UIKit

var isOpenDetailTagCell = [Bool]()

class DetailTagViewController: UITableViewController, SlideNavigationControllerDelegate {
    var detailTagTasks = [Task]()
    
    func shouldDisplayMenu() -> Bool {
        return false
    }
    
    init(tag: Tag) {
        super.init(nibName: nil, bundle: nil)
        title = tag.name

        isOpenDetailTagCell = [Bool]()
        for i in 0...sectionItems.count-1 {
            if sectionItems[i].count > 0 {
                for j in 0...sectionItems[i].count-1 {
                    if sectionItems[i][j].tag === tag {
                        detailTagTasks.append(sectionItems[i][j])
                        isOpenDetailTagCell.append(false)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        tableView.registerClass(DetailTagCell.self, forCellReuseIdentifier: NSStringFromClass(DetailTagCell))
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return detailTagTasks.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(DetailTagCell), forIndexPath: indexPath) as DetailTagCell
        cell.configureWithList(detailTagTasks[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return detailTagCellHeight
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}