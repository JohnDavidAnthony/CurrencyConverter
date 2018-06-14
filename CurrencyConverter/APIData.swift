//
//  APIDatahandler.swift
//  CurrencyConverter
//
//  Created by John David Anthony on 2018-06-13.
//  Copyright © 2018 John David Anthony. All rights reserved.
//

import Foundation

struct Test: Decodable {
    let rates: [String: Double]
}

class APIDataHandler{
    
    func getDataFromURL(urlString: String, object: Decodable, completionHandler: @escaping ((Data) -> Void)) {
        let url = URL(string: urlString)
        //Get the json data from the URL
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                //Decode retrived data with JSONDecoder
                //general Decodable.Type isn't enough so I need the concrete 
                let output = try JSONDecoder().decode(object.self, from: data!)
                
                completionHandler(output)
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    //let url = URL(string: "http://data.fixer.io/api/latest?access_key=83efe7edb3691dfe8b302259bffbff66&symbols=USD,AUD,CAD,PLN,MXN&format=1")

    
}
