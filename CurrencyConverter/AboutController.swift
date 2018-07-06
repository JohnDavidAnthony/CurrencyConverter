//
//  AboutController.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-07-05.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import UIKit

class AboutController: UIViewController{
    
    @IBOutlet weak var aboutDescription: UITextView!
    override func viewDidLoad() {
        //Creates a gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 0, green: 0.7176, blue: 0.898, alpha: 1.0).cgColor, UIColor(red: 0.2627, green: 0.5961, blue: 0.949, alpha: 1.0).cgColor]
        self.view.layer.addSublayer(gradientLayer)
        
        //Bring Label to front
        view.bringSubviewToFront(aboutDescription)
    }
    
}
