//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-10.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

let apiKey = "83efe7edb3691dfe8b302259bffbff66"

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //Extends TableViewDelegate and TableViewDataSource Because..........
    
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
        return headerView //Lol really, thats all you need to do 🔫
    }
    //Return the height of the header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70)
    }
    
    //Create Cell with dequeue resuable cell at the current index and with our Reuse Identifier
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Dequeue method allows for greater efficiency as we reuse cells when they are not in view
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryConverter", for: indexPath) as! CellView
        //Identifier is from storyboard
        
        //Pass to configure cell which creates a UI item from the CellDataObject data for each element in Cell Array
        cell.configureCell(cell: cellArray[indexPath.item])
        return cell
    }
    
    //Called whenever cell was tapped, initiating a segue to the detailed conversion scene
    var selectedCell = CellDataObject()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = cellArray[indexPath.item]
        performSegue(withIdentifier: "detailed", sender: tableView.self)
        print(indexPath.item)
    }
    
    //Called whenever a segue is about to occur, gives me time to send data to upcoming VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Switch statment to differentiate what segues are occuring
        switch segue.identifier {
        case "detailed":
            
            //Temporary passing of vars TOBe Updated
            let detailedVC = segue.destination as! DetailedInformationController
            detailedVC.selectedCell = selectedCell
            
        default:
            print("Error: Segue not setup")
        }
    }
    
    //Update the currency exchange rate
    @objc func updateRates(countries: [String], baseCountry: String) {
        //Create Request String
        var request = ""
        for country in countries {
            request += country + ","
        }
        //remove last char to get rid of ','
        request.removeLast()
        
        //Gets the data from the api and updates the cells
        let apiHandler = APIDataHandler()
        apiHandler.getDataFromURL(urlString: "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=\(request)&format=1", completionHandler: {(data) in
            
            //Free API doesn't let me choose base so here is the logic to show the conversion on chosen base
            //Get base country's rate so that we can divide all of the currencys by that amount
            let base = data.rates[baseCountry]
            
            //Updates each cells convert amount adjusted for base country's rate
            for cell in self.cellArray {
                let amount = (data.rates[cell.country]! / base!)
                // Round to 5 decimal places and assign to cell
                cell.convertAmount = Double(round(amount*100000)/100000)
            }
         
            //Call reload data in main thread because....?
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    
     var refreshControl: UIRefreshControl?

    //objc wrapper for #selector
    @objc func refreshView() {
        var countryArray: [String] = []
        for country in cellArray {
            countryArray.append(country.country)
        }
        //UDPATE THIS_________________________________________________-
        updateRates(countries: countryArray, baseCountry: "CAD")
        
        //You get the spinner to go away by ending animation in the update rates for some reason?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Testing _______________ REMOVE
        cellArray.append(CellDataObject(path: "usd.png", country: "USD", amount: 0.8366))
        cellArray.append(CellDataObject(path: "cad.png", country: "CAD", amount: 1))
        cellArray.append(CellDataObject(path: "gbp.png", country: "GBP", amount: 0.5532))
        cellArray.append(CellDataObject(path: "eur.png", country: "EUR", amount: 0.6543))

        let refreshControl = UIRefreshControl()
        // Add Refresh Control to Table View
        tableView.refreshControl = refreshControl

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Rates", attributes: nil)

        //Set self to be delegate and data source because....... TODO
        tableView.delegate = self
        tableView.dataSource = self
    }
}

