//
//  OfficialsDetails.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/24/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//
import UIKit
import Foundation

class OfficialsDetailsVC: UIViewController
{
    var official: Official!;
    var users_state: String?;
    @IBOutlet weak var Picture: UIImageView!;
    @IBOutlet weak var JobTitle: UILabel!;
    @IBOutlet weak var Party: UILabel!;
    @IBOutlet weak var HomePage: UITextView!;
    @IBOutlet weak var PhoneNumber: UITextView!;
    @IBOutlet weak var Email: UITextView!;
    @IBOutlet weak var Address: UITextView!;
    let customColor = UIColor(red:0.58, green:0.80, blue:0.91, alpha:1.0);

    override func viewDidLoad() {
        super.viewDidLoad()
        self.HTTPGetImage();
        self.view.backgroundColor = self.customColor;
        self.title = self.official.name;
        self.JobTitle.text = self.official.officeTitle;
        self.Party.text = self.official.party;
        self.setUITextView(textView: self.HomePage, title: "Urls", data: self.official.urls);
        self.setUITextView(textView: self.Email, title: "Emails", data: self.official.emails);
        self.setUITextView(textView: self.PhoneNumber, title: "Phones", data: self.official.phones);
        self.setUITextView(textView: self.Address, title: "Offices", data: self.official.address);
    }
    
    func setUITextView(textView: UITextView, title: String, data: [String]){
        var text = title + ":\n";
        if data.count == 0{ text += "N/A"; }
        let append = data.count > 1 ? "* " : "";
        for i in 0..<data.count{
            text += "\(append)\(data[i])\n";
        }
        textView.text = text;
        textView.backgroundColor = self.customColor;
    }
    
    func setUITextView(textView: UITextView, title: String, data: [Address]){
        var text = title + ":\n";
        if data.count == 0{ text += "N/A"; }
        let append = data.count > 1 ? "* " : "";
        for i in 0..<data.count{
            text += "\(append)\(data[i].toString())\n";
        }
        textView.text = text;
        textView.backgroundColor = self.customColor;
    }
    
    
    func setImageProps(_ img: UIImageView){
        img.clipsToBounds = true;
        let width = img.bounds.size.height;
        img.layer.cornerRadius = width * 0.3;
        img.layer.borderWidth = 5;
        img.backgroundColor = .white;
        img.layer.borderColor = UIColor.white.cgColor;
    }
    
    
    func createImageUrl() -> URL? {
        var url_str = "https://vote-ma.org/Image.aspx?Id=";
        url_str += self.official.address.last?.state ?? self.users_state ?? "";
        var tokens = self.official.name.components(separatedBy: " ");
        let count = tokens.count;
        switch(count){
        case 3:
            url_str += tokens[2];//last name
            url_str += tokens[0];//first name
            url_str += tokens[1].dropLast(1); //middle name w/out '.'
            break;
        case 2:
            url_str += tokens[1]; //last name
            url_str += tokens[0]; //first name
            break;
        default:
            return URL(string: "https://vote-ma.org/Image.aspx?Id=");
        }
        //removes accents from strings
        url_str = url_str.folding(options: .diacriticInsensitive, locale: NSLocale.current);
        return URL(string: url_str);
    }

    func HTTPGetImage(){
        var url: URL? = URL(string: self.official.photoUrl);
        var data: Data?;
        do{
            if url == nil { throw NSError(); }
            data = try Data(contentsOf: url!);
        }
        catch{
            url = self.createImageUrl();
            data = try? Data(contentsOf: url!);
        }
        self.Picture.image = UIImage(data: data!);
        self.setImageProps(self.Picture);
    }
}
