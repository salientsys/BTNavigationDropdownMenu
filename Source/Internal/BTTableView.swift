//
//  BTTableView.swift
//
//  Copyright (c) 2017 PHAM BA THO (phambatho@gmail.com). All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class BTTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // Public properties
    var configuration: BTConfiguration!
    var itemSelectionHandler: ((BTMenuItem) -> ())?
    
    // Private properties
    var items: [BTMenuItem] = []
    var selectedIndexPath: Int?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, items: [BTMenuItem], selectedItemId: Int?, configuration: BTConfiguration) {
        super.init(frame: frame, style: UITableView.Style.plain)
        
        self.items = items
        self.selectedIndexPath = items.firstIndex { $0.id == selectedItemId }
        self.configuration = configuration
        
        // Setup table view
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.clear
        self.tintColor = .white
        self.separatorColor = configuration.cellSeparatorColor
        self.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        //        self.separatorEffect = UIBlurEffect(style: .Light)
        self.tableFooterView = UIView(frame: CGRect.zero)

        register(BTTableViewCell.self, forCellReuseIdentifier: String(describing: BTTableViewCell.self))
    }

    // Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.configuration.cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: BTMenuItem = items[indexPath.row]
        let reuseIdentifier = String(describing: BTTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! BTTableViewCell
        cell.configure(with: self.configuration)
        cell.textLabel?.text = item.title
        cell.accessoryType = (indexPath.row == selectedIndexPath) ? .checkmark : .none
        cell.imageView?.image = item.icon

        return cell
    }
    
    // Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = (indexPath as NSIndexPath).row
        let item = items[indexPath.row]
        self.itemSelectionHandler?(item)
    }    
}
