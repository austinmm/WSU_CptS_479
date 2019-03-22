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

//Reference: https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift
//Used to convert html encoded strings into plain text
extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
