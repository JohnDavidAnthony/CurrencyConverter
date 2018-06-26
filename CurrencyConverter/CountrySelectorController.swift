//
//  CountrySelectorController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-14.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import Foundation
import UIKit

class CountrySelectorController: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var countries = [String : String]()
    var pickedCountry = String()
    var keys = [String]()
    var values = [String]()
    
    let test = ["tes","dadw"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return keys.count
        return test.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //return values[row]
        return test[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedCountry = keys[row]
    }
}
