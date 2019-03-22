//
//  API_Calls.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/20/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation

class API_Calls{
    static let Decoder = JSONDecoder();
    static func Get(_ type : ElectionType){
        let url = URL(string: "http://www.eecs.wsu.edu/~holder/tmp/date.php");
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler: HandleGetResponse);
        dataTask.resume();
    }
    
    static func HandleGetResponse(data: Data?, response: URLResponse?, error: Error?){
        if let err = error {
            print("error: \(err.localizedDescription)")
        } else {
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            if statusCode != 200 {
                let msg = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                print("HTTP \(statusCode) error: \(msg)")
            } else {
                // response okay, do something with data
                //let product = try Decoder.decode(<class>, from: <json>);
            }
        }
    }
}
