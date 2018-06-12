//
//  CellView.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-10.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {
    
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var convertAmountLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    //Configures the cell by getting the Cell Data and assigning it to a UI Item
    func configureCell (cell: CellDataObject){
        countryImageView.image = UIImage(named: cell.countryImagePath)
        convertAmountLabel.text = String(cell.convertAmount)
        countryLabel.text = cell.country
    }    
}


