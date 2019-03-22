//
//  Election.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/19/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation

class Election {
    var Title: String = "";
    var Canidates: [String] = [];
    init(title: String, canidates: [String]){
        self.Title = title;
        self.Canidates = canidates;
    }
}
