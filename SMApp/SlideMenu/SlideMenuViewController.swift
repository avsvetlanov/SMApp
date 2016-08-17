//
//  SlideMenuViewController.swift
//  SMApp
//
//  Created by  Svetlanov on 16.08.16.
//  Copyright © 2016  Svetlanov. All rights reserved.
//

import UIKit

class SlideMenuViewController: UITableViewController {

    private var items : [String] = ["1 Пункт Меню",
                                    "2 Пункт Меню",
                                    "3 Пункт Меню",
                                    "4 Пункт Меню",
                                    "5 Пункт Меню"]
    
    private let cellIdentifier : String = "Cell"
    
    private var delegate : SlideMenuDelegate!
    
    private var backgroundColor : UIColor = UIColor.grayColor()
    private var textColor : UIColor = UIColor.blackColor()
    
    init(delegate: SlideMenuDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.tableView.backgroundColor = backgroundColor
        self.tableView.separatorStyle = .None
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.didSelectMenuItem(indexPath.row + 1)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        cell.textLabel?.text = items[indexPath.row]
        cell.backgroundColor = backgroundColor
        cell.textLabel?.textColor = textColor
        return cell
    }
}
