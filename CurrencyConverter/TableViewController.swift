//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-10.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Extends TableViewDelegate and TableViewDataSource Because..........
    
    //fileprivate makes variable private to everything outside of this file
    @IBOutlet var tableView: UITableView!
    
    //Cell Array holds the data of each country cell
    fileprivate var cellArray = [CellDataObject]()
    
    
    //Returns the number of items in cellArray, the number of rows we want in the table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    //Returns a UITableViewHeaderFooterView outlet that was created in the storyboard
    //This SUCKED to implement, got the answer from here: https://stackoverflow.com/questions/30149551/tableview-section-headers-disappear-swift
    @IBOutlet var headerView: UITableViewHeaderFooterView!
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    //Return the height of the header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create Cell with dequeue resuable cell at the current index and with our Reuse Identifier
        //Dequeue method allows for greater efficiency as we reuse cells when they are not in view
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryConverter", for: indexPath) as! CellView
        //Identifier is from storyboard
        
        //Pass to configure cell which creates a UI item from the CellDataObject data for each element in Cell Array
        cell.configureCell(cell: cellArray[indexPath.item])
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing _______________ REMOVE
        cellArray.append(CellDataObject(path: "usd.png", country: "USD", amount: 0.8366))
        cellArray.append(CellDataObject(path: "cad.png", country: "CAD", amount: 1))
        cellArray.append(CellDataObject(path: "gbp.png", country: "GBP", amount: 0.5532))
        cellArray.append(CellDataObject(path: "eur.png", country: "EURO", amount: 0.6543))

        

        //Set self to be delegate and data source because....... TODO
        tableView.delegate = self
        tableView.dataSource = self
    }
}

