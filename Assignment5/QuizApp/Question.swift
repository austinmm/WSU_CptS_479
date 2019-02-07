//
//  Question.swift
//  QuizApp
//
//  Created by Austin Marino on 1/15/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation

class Question{
    var QuizPrompt: String;
    var Answers: [String];
    var CorrectAnswer: Int;
    init(QuizPrompt: String, Answers: [String], CorrectAnswer: Int) {
        self.QuizPrompt = QuizPrompt;
        self.Answers = Answers;
        self.CorrectAnswer = CorrectAnswer;
    }
}

let Prompt: [String] =
[
    "What is the largest Island in the world?",
    "What is the diameter of Earth in miles?",
    "What is the worlds largest Ocean?",
    "What colour jersey is worn by the winners of each stage of the Tour De France?",
    "How many valves does a trumpet have?",
    "What year was William Shakespeare born?",
    "Acorns come from which species of tree?",
    "Hummingbirds can fly backwards."
];

let Answers: [[String]] =
[
    ["Ireland", "Hawaii", "Greenland", "Iceland", "Bali"],
    ["6,000", "25,000", "500,000", "8,000"],
    ["Pacific", "Atlantic", "Indian", "Artic", "Southern"],
    ["Green", "Yellow", "Blue", "Crimson"],
    ["3", "5", "2"],
    ["1501", "1439", "1678", "1564"],
    ["Sequoia", "Redwood", "Oak", "Palm"],
    ["True", "False"]
];

let CorrectAnswers: [Int] =
[
    2,3,0,1,0,3,2,0
];

