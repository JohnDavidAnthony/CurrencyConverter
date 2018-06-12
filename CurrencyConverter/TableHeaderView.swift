//
//  TableHeaderView.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-12.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class TableHeaderView: UIView {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerInput: UITextField!
    
    
    func configureHeader(header: TableHeaderObject){
        headerImage.image = UIImage(named: header.path)
    }
}
