//
//  DetailedInformationController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-12.
//  Copyright © 2018 John David Anthony. All rights reserved.
//
import Foundation
import UIKit

class DetailedInformationController: UIViewController{
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var countryRate: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    
    var selectedCell = CellDataObject()

    
    override func viewDidLoad(){
        super.viewDidLoad()
        //Update the values of the UI Elements
        countryLabel.text = selectedCell.country
        countryRate.text = String(selectedCell.convertAmount)
        countryImage.image = UIImage(named: selectedCell.countryImagePath)
    }
}
