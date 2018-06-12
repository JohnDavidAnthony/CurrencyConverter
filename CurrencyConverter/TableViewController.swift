//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-10.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    fileprivate var cellArray = [CellDataObject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Create Cell with dequeue resuable cell at the current index and with our Reuse Identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! CellView
        cell.configureCell(cell: cellArray[indexPath.item])
        return cell
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Test
        //fileprivate makes variable private to everything outside of this file
        
        let cell1 = CellDataObject(path: "usd.png",country: "USD",amount: 0.836)
        cellArray.append(cell1)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        

        // Do any additional setup after loading the view, typically from a nib.
        
        //Using Reuse Identifier to only resuse the cells as they are off the screen
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BetterTableViewCell")
        //Set self to be delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
 
    }

    


}

