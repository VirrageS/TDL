//
//  TagViewController.swift
//  TDL
//
//  Created by Janusz Marcinkiewicz on 25.08.2014.
//  Copyright (c) 2014 VirrageS. All rights reserved.
//

import UIKit

class TagViewController: UITableViewController {
    override init() {
        super.init(nibName: nil, bundle: nil)
        title = "Tags"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "openAddTagController:")
        navigationItem.rightBarButtonItem = addButtonItem
        
        
        print(navigationController)
        let image: UIImage = UIImage(named: "menu-button") as UIImage
        let menuButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Bordered, target: self, action: "popBack:")
        //barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "openMenuController:")
//        navigationItem.leftBarButtonItem = menuButtonItem
        
        
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorColor = UIColor.whiteColor()
        tableView.registerClass(TagCell.self, forCellReuseIdentifier: NSStringFromClass(TagCell))
    }
    
//    override func dealloc() {
//        tableView.dataSource = nil
//        tableView.delegate = nil
//    }

    func popBack() {
        println("Hello")
//        print(navigationController)
        //view.endEditing(true)
        //navigationController.popToRootViewControllerAnimated(true);
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TagCell), forIndexPath: indexPath) as TagCell
        cell.configure(indexPath.row)
        return cell as TagCell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return tagCellHeight
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func openAddTagController(sender: AnyObject) {
        let addTagViewController = AddTagViewController()
        navigationController.pushViewController(addTagViewController, animated: true)
    }
    
    func openMenuController(sender: AnyObject) {
        let menuViewController = MenuViewController()
        navigationController.pushViewController(menuViewController, animated: true)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}