//
//  HeaderView.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-12.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var input: UITextField!
    @IBOutlet weak var label: UILabel!
    
    func configureHeader (){
        countryImage.image = UIImage(named: "cad.png")
    }
}
