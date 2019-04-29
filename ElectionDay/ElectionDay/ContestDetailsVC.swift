//
//  PollingPlaceVC.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/21/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import UIKit

class ContestDetailsVC: UIViewController
{
    var contest: Contest!;
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);
    @IBOutlet weak var ElectionType: UILabel!;
    @IBOutlet weak var CanidateInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.title = self.contest.type + " Election";
        self.view.backgroundColor = self.customColor;
        self.ElectionType.text = self.contest.office;
        self.CanidateInfo.backgroundColor = self.customColor;
        self.CanidateInfo.layer.borderColor = UIColor.white.cgColor;
        self.CanidateInfo.layer.borderWidth = 1;
        self.setCanidateInfo();
    }
    
    func setCanidateInfo(){
        var html_str = "<div style='color: white'><ol>";
        for i in 0..<self.contest.candidates.count{
            let canidate = self.contest.candidates[i];
            html_str +=
            """
            <li><font size='6'><strong>\(canidate.name)</strong></font>
            <ul style='text-decoration: none'>
                <li><font size='5'><strong>Party:</strong> \(canidate.party)</font></li>
                <li><font size='5'><strong>Phone:</strong> \(canidate.phone)</font></li>
                <li><font size='5'><strong>Email:</strong><font size='3'> \(canidate.email)</font></font></li>
            """;
            for channel in canidate.channels{
                html_str +=
                """
                    <li><font size='5'><strong>\(channel.type):</strong><font size='3'> \(channel.id)</font></font></li>
                """;
            }
            html_str +=
            """
                </ul>
            </li>
            """;
        }
        html_str += "</ol></div>";
        do{
            let data = try! Data(html_str.utf8);
            if let attributedString = try?NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                self.CanidateInfo.attributedText = attributedString;
            }
            else{
                self.CanidateInfo.text = html_str;
            }
        }
        catch{
            self.CanidateInfo.text = html_str;
        }
    }
    
}
