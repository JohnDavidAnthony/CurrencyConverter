//
//  TableViewController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-10.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

let apiKey = "83efe7edb3691dfe8b302259bffbff66"

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

//TableView Functions here
    
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
        return CGFloat(90)
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
    
    // Allows me to set the actions for when a user swipes on a cell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Create a delete action
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: { (action, index) in
            self.cellArray.remove(at: indexPath.row)
            //Make sure to update the tableview
            self.tableView.reloadData()
        })
        
        //return the actions
        return [delete]
    }
    
    // Add a cell
    @IBAction func addButton(_ sender: Any) {
        addingCellTextField.becomeFirstResponder()
        print("Run")
    }
    @IBOutlet weak var addingCellTextField: UITextField!
    @IBAction func addingCellDoneEditing(_ sender: Any) {
        var existing = false
        // Check to see if country is already selected
        for cell in cellArray {
            if cell.country == keys[countryPickerSelectedRow] {
                existing = true
            }
        }
        if !existing {
            cellArray.append(CellDataObject(path: keys[countryPickerSelectedRow] + ".png", country: keys[countryPickerSelectedRow], amount: 0))
            //Make sure to update the tableview
            updateRates()
        }
        
    }
    
    
    // Called whenever a segue is about to occur, gives me time to send data to upcoming VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Switch statment to differentiate what segues are occuring
        switch segue.identifier {
        case "detailed":
            
            // Temporary passing of vars TOBe Updated
            let detailedVC = segue.destination as! DetailedInformationController
            detailedVC.selectedCell = selectedCell
            break
            
        default:
            print("Error: Segue not setup")
        }
    }
    
    //Update the currency exchange rate
    var keys = [String]()
    var values = [String]()
    @objc func updateRates() {
        
    //Get all country Names currently in the table view
        var countryArray: [String] = []
        for country in cellArray {
            countryArray.append(country.country)
        }
        
        //Create Request String
        var request = ""
        for country in countryArray {
            request += country + ","
        }
        //Add basecountry to api call
        request += self.base
        
        //Gets the data from the api and updates the cells
        let apiHandler = APIDataHandler()
        apiHandler.getDataFromURL(urlString: "http://data.fixer.io/api/latest?access_key=\(apiKey)&symbols=\(request)&format=1", completionHandler: {(data) in
            
            //Free API doesn't let me choose base so here is the logic to show the conversion on chosen base
            
            //Get base country's rate so that we can divide all of the currencys by that amount
            let baseRate = data.rates[self.base]
            
            //Updates each cells convert amount adjusted for base country's rate
            for cell in self.cellArray {
                let amount = (data.rates[cell.country]! / baseRate!)
                // Round to 5 decimal places and assign to cell
                cell.convertAmount = Double(round(amount * self.baseAmount * 100000)) / 100000
            }
         
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        //Get all Aviliable Currencies
        apiHandler.getAvailableCurrencies(apiKey: apiKey, completionHandler: { (data) in
            //Sorts the dictionary alphabetically by key, from: https://stackoverflow.com/questions/25377177/sort-dictionary-by-keys
            let sorted = data.symbols.sorted { $0.key < $1.key }
            let keysArraySorted = Array(sorted.map({ $0.key }))
            let valuesArraySorted = Array(sorted.map({ $0.value }))
            
            self.keys = keysArraySorted
            self.values = valuesArraySorted
            
            DispatchQueue.main.async {
                self.picker.keys = self.keys
                self.picker.values = self.values
                self.picker.reloadAllComponents()
                
                //Update Country Name
                self.countryNameLabel.text = data.symbols[self.base]
            }
        })
    }
    

    
//objc wrapper for #selector
    var base = "CAD"
    @objc func refreshView() {
        updateRates()
        
        DispatchQueue.main.async(execute: {
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.contentOffset = CGPoint.zero
        })
    }

//Update the value of all cells based on amount entered
//TODO Fix issue of mroe than one decimal entered by user
    @IBOutlet weak var currencyTextField: UITextField!
    var baseAmount: Double = 1.00
    @IBAction func currecyEditingEnd(_ sender: Any) {
        if currencyTextField.text == "" {
            baseAmount = 1
        } else{
            baseAmount = Double(currencyTextField.text!)!
        }
        updateRates()
    }

//Because I am using a decimal keyboard, it has no done button
//Creates custom done button
    func customDoneButton(textField: UITextField){
        //Create Tool Bar
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        
        //Create Done Button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(keyboardAway))
        
        //Create Cancel Button
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(keyboardAway))
        
        
        // Create Flexible space so that cancel and done are aligned to the edges
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        //Add done button to tool bar
        toolbar.items = [cancelButton, flexibleSpace, doneButton]
        //Add toolbar as an accessory view
        textField.inputAccessoryView = toolbar
        
    }
    //Resigns the keyboard
    @objc func keyboardAway(){
        print("run")
        view.endEditing(true)
        //Todo Figure out why cell text field will not resign
        addingCellTextField.endEditing(true)
    }

    @IBOutlet weak var baseCountryTextField: UITextField!
    // Set the picker to update base when done editing
    @IBAction func countryPickerDoneEditing(_ sender: Any) {
        let path: String = keys[countryPickerSelectedRow] + ".png"
        //Check to see if I have a photo for the selected country
        let image =  UIImage(named: path)
        if image == nil {
            //Image does not exist, fallback
            baseCountryTextField.text = keys[countryPickerSelectedRow]
        }else{
            //Image Exists, Remove text
            baseCountryTextField.text = ""
        }
        baseCountryTextField.background = UIImage(named: path)
        base = keys[countryPickerSelectedRow]
        updateRates()
    }
    
//Load Up Everything I need when the view loads
    var picker = CountrySelectorController()
    override func viewDidLoad() {
        super.viewDidLoad()

        let refreshControl = UIRefreshControl()
        // Add Refresh Control to Table View
        tableView.refreshControl = refreshControl

        // Configure Refresh Control
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Rates", attributes: nil)

        //Get API Data
        refreshView()
        
        //Create a UIPicker as that will choose the base country
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        //Add the UIPicker as the keyboard view
        baseCountryTextField.inputView = picker
        addingCellTextField.inputView = picker
        
        //Add the custom done button to the keyboard maybe Remove?
        customDoneButton(textField: currencyTextField)
        customDoneButton(textField: baseCountryTextField)
        customDoneButton(textField: addingCellTextField)
        
        //Set the tableview delegate & dataSource
        tableView.delegate = self
        tableView.dataSource = self
    }
    

//Country UIPicker Functions
    @IBOutlet weak var countryNameLabel: UILabel!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return values[row]
    }
    
    var countryPickerSelectedRow = 0
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryPickerSelectedRow = row
    }
}

