//
//  MyTimer.swift
//  QuizApp
//
//  Created by Austin Marino on 1/28/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation
protocol MyTimerDelegate {
    func timeChanged (time: Int)
    func timesUp (message: String)
}
class MyTimer {
    var initialTime: Int
    var currentTime: Int
    var message: String
    var running: Bool
    var delegate: MyTimerDelegate?
    init (initialTime: Int, message: String) {
        self.initialTime = initialTime
        self.currentTime = initialTime
        self.message = message
        self.running = false
    }
    func start () {
        running = true
    }
    func stop () {
        running = false
    }
    func reset () {
        currentTime = initialTime
        delegate?.timeChanged(time: currentTime)
    }
    func decrement () {
        if running {
            currentTime -= 1
            delegate?.timeChanged(time: currentTime)
            if currentTime == 0 {
                running = false
                delegate?.timesUp(message: self.message)
            }
        }
    }
}
