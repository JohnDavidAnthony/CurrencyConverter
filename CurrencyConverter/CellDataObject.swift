//
//  CellDataObject.Swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-11.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import Foundation

//Class which holds the data for the cell object
class CellDataObject {
    var countryImagePath: String
    var country: String
    var convertAmount: Double
    
    init(path: String, country: String, amount: Double) {
        self.countryImagePath = path
        self.country = country
        self.convertAmount = amount
    }
}


