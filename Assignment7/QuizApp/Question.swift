//
//  Question.swift
//  QuizApp
//


import Foundation

class Question {
    var prompt: String?;
    var answers: [String] = [];
    var correctAnswerIndex: Int = 0;
    var uniqueId: String;
    init(){
        self.uniqueId = UUID().uuidString;
    }
}
