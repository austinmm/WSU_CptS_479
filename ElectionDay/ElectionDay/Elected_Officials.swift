//
//  RepresentativeInfo.swift
//  ElectionDay
//
//  Created by Austin Marino on 4/22/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation;
import Firebase;

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

struct ElectedOfficials
{
    var officials: [Official] = [Official]();
    var offices: [Office] = [Office]();
    var ref: DatabaseReference?;
    
    init(officials: [Official], offices: [Office])
    {
        self.officials = officials;
        self.offices = offices;
    }
    
    init(){
        self.officials = [Official]();
        self.offices = [Office]();
    }
}

extension ElectedOfficials: Decodable
{
    // declaring our keys
    enum ElectedOfficialsKeys: String, CodingKey
    {
        case officials = "officials";
        case offices = "offices";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ElectedOfficialsKeys.self) // defining our (keyed) container
        //extracting the data
        self.officials = try container.decode([Official].self, forKey: .officials);
        self.offices = try container.decode([Office].self, forKey: .offices);
    }
    
    init(snapshot: DataSnapshot)
    {
        self.ref = snapshot.ref;
        let value = snapshot.value as! [String: Any];
        self.officials = value["officials"] as! [Official];
        self.offices = value["offices"] as! [Office];
    }
    
    init(snapshot: QueryDocumentSnapshot)
    {
        let value = snapshot.data();
        let officials_list = value["officials"] as! [[String: Any]];
        for val in officials_list{
            self.officials.append(Official(value: val));
        }
        let office_list = value["offices"] as! [[String: Any]];
        for val in office_list{
            self.offices.append(Office(value: val));
        }
    }
    
    func toDict() -> [String: Any] {
        var officialsDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.officials.count{
            officialsDict.append(self.officials[i].toDict());
        }
        var officesDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.offices.count{
            officesDict.append(self.offices[i].toDict());
        }
        let dict: [String: Any] =
            ["officials": officialsDict, "offices": officesDict];
        return dict;
    }
    
}

struct Office{
    var name: String;
    var divisionId: String;
    var officialIndices: [Int];
    var ref: DatabaseReference?;
    
    init(name: String, divisionId: String, officialIndices: [Int])
    {
        self.name = name;
        self.divisionId = divisionId;
        self.officialIndices = officialIndices;
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: Any];
        self.name = value["name"] as! String;
        self.divisionId = value["divisionId"] as! String;
        self.officialIndices = value["officialIndices"] as! [Int];
    }
    
    init(snapshot: QueryDocumentSnapshot){
        let value = snapshot.data();
        self.name = value["name"] as! String;
        self.divisionId = value["divisionId"] as! String;
        self.officialIndices = value["officialIndices"] as! [Int];
    }
    
    init(value: [String: Any]){
        self.name = value["name"] as! String;
        self.divisionId = value["divisionId"] as! String;
        self.officialIndices = value["officialIndices"] as! [Int];
    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] =
            ["name": self.name, "divisionId": self.divisionId,
             "officialIndices": self.officialIndices];
        return dict;
    }
}

extension Office: Decodable
{
    // declaring our keys
    enum OfficeKeys: String, CodingKey
    {
        case name = "name";
        case divisionId = "divisionId";
        case officialIndices = "officialIndices";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: OfficeKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.name = try container.decode(String.self, forKey: .name);
        } catch {
            self.name = "";
        }
        do{
            self.divisionId = try container.decode(String.self, forKey: .divisionId);
        } catch {
            self.divisionId = "";
        }
        do{
            self.officialIndices = try container.decode([Int].self, forKey: .officialIndices);
        } catch {
            self.officialIndices = [Int]();
        }
    }
}

struct Official
{
    var name: String;
    var address: [Address] = [Address]();
    var party: String;
    var phones: [String];
    var urls: [String];
    var photoUrl: String;
    var emails: [String];
    var channels: [Channel] = [Channel]();
    var officeTitle: String;
    
    var ref: DatabaseReference?;
    
    init(name: String, address: [Address], party: String, phones: [String],
         urls: [String], photoUrl: String, channels: [Channel], emails: [String], officeTitle: String)
    {
        self.name = name;
        self.address = address;
        self.party = party;
        self.phones = phones;
        self.urls = urls;
        self.photoUrl = photoUrl;
        self.emails = emails;
        self.channels = channels;
        self.officeTitle = officeTitle;
    }
    
    init(snapshot: DataSnapshot)
    {
        self.ref = snapshot.ref;
        let value = snapshot.value as! [String: Any];
        self.name = value["name"] as! String;
        self.address = value["address"] as! [Address];
        self.party = value["party"] as! String;
        self.phones = value["phones"] as! [String];
        self.urls = value["urls"] as! [String];
        self.photoUrl = value["photoUrl"] as! String;
        self.emails = value["emails"] as! [String];
        self.channels = value["channels"] as! [Channel];
        self.officeTitle = value["officeTitle"] as! String;
    }
    
    init(snapshot: QueryDocumentSnapshot)
    {
        let value = snapshot.data();
        self.name = value["name"] as! String;
        let address_list = value["address"] as! [[String: Any]];
        for val in address_list{
            self.address.append(Address(value: val));
        }
        self.party = value["party"] as! String;
        self.phones = value["phones"] as! [String];
        self.urls = value["urls"] as! [String];
        self.photoUrl = value["photoUrl"] as! String;
        self.emails = value["emails"] as! [String];
        self.officeTitle = value["officeTitle"] as! String;
        let channel_list = value["channels"] as! [[String: Any]];
        for val in channel_list{
            self.channels.append(Channel(value: val));
        }
    }
    
    init(value: [String: Any])
    {
        self.name = value["name"] as! String;
        let address_list = value["address"] as! [[String: Any]];
        for val in address_list{
            self.address.append(Address(value: val));
        }
        self.party = value["party"] as! String;
        self.phones = value["phones"] as! [String];
        self.urls = value["urls"] as! [String];
        self.photoUrl = value["photoUrl"] as! String;
        self.emails = value["emails"] as! [String];
        self.officeTitle = value["officeTitle"] as! String;
        let channel_list = value["channels"] as! [[String: Any]];
        for val in channel_list{
            self.channels.append(Channel(value: val));
        }
    }
    
    func toDict() -> [String: Any] {
        var addressDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.address.count{
            addressDict.append(self.address[i].toDict());
        }
        var channelsDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.channels.count{
            channelsDict.append(self.channels[i].toDict());
        }
        let dict: [String: Any] =
            ["name": self.name, "address": addressDict, "party": self.party,
             "phones": self.phones, "urls": self.urls, "photoUrl": photoUrl,
             "emails": self.emails, "channels": channelsDict, "officeTitle": self.officeTitle];
        return dict;
    }
}

extension Official: Decodable
{
    // declaring our keys
    enum OfficialKeys: String, CodingKey
    {
        case name = "name";
        case address = "address";
        case party = "party";
        case phones = "phones";
        case urls = "urls";
        case photoUrl = "photoUrl";
        case emails = "emails";
        case channels = "channels";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: OfficialKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.name = try container.decode(String.self, forKey: .name);
        } catch {
            self.name = "";
        }
        do{
            self.address = try container.decode([Address].self, forKey: .address);
        } catch {
            self.address = [Address]();
        }
        do{
            self.party = try container.decode(String.self, forKey: .party);
        } catch{
            self.party = "";
        }
        do{
            self.phones = try container.decode([String].self, forKey: .phones);
        } catch{
            self.phones = [String]();
        }
        do{
            self.photoUrl = try container.decode(String.self, forKey: .photoUrl);
        } catch {
            self.photoUrl = "";
        }
        do{
            self.emails = try container.decode([String].self, forKey: .emails);
        } catch {
            self.emails = [String]();
        }
        do{
            self.urls = try container.decode([String].self, forKey: .urls);
        } catch{
            self.urls = [String]();
        }
        do{
            self.channels = try container.decode([Channel].self, forKey: .channels);
            //adds all the elected official's twitter, facebook and youtube to their urls field
            for channel in self.channels{
                if let _url = channel.url{
                    self.urls.append(_url);
                }
            }
        } catch {
            self.channels = [Channel]();
        }
        self.officeTitle = "";
    }
}

struct Channel
{
    var type: String;
    var id: String;
    var url: String?;
    
    init(type: String, id: String)
    {
        self.type = type;
        self.id = id;
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: Any];
        self.type = value["type"] as! String;
        self.id = value["id"] as! String;
    }
    
    init(snapshot: QueryDocumentSnapshot){
        let value = snapshot.data();
        self.type = value["type"] as! String;
        self.id = value["id"] as! String;
    }
    
    init(value: [String: Any]){
        self.type = value["type"] as! String;
        self.id = value["id"] as! String;
    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] =
            ["type": self.type, "id": self.id];
        return dict;
    }
}

extension Channel: Decodable
{
    // declaring our keys
    enum ChannelKeys: String, CodingKey
    {
        case type = "type";
        case id = "id";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ChannelKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.type = try container.decode(String.self, forKey: .type);
        } catch {
            self.type = "";
        }
        do{
            self.id = try container.decode(String.self, forKey: .id);
        } catch {
            self.id = "";
        }
        self.url = self.type_to_url();
    }
    
    func type_to_url() -> String? {
        if(self.id.contains("https")){
            return self.id;
        }
        switch(self.type){
        case "Twitter":  return "https://twitter.com/\(self.id)";
        case "Facebook": return "https://facebook/\(self.id)";
        case "YouTube":  return "https://www.youtube.com/\(self.id)";
        default:         return nil;
        }
    }
}

struct Address
{
    var locationName: String;
    var line1: String;
    var line2: String;
    var line3: String;
    var city: String;
    var state: String;
    var zip: String;
    init()
    {
        self.locationName = "";
        self.line1 = "";
        self.line2 = "";
        self.line3 = "";
        self.city = "";
        self.state = "";
        self.zip = "";
    }
    
    init(locationName: String, line1: String, line2: String,
         line3: String, city: String, state: String, zip: String)
    {
        self.locationName = locationName;
        self.line1 = line1;
        self.line2 = line2;
        self.line3 = line3;
        self.city = city;
        self.state = state;
        self.zip = zip;
    }
    
    init(snapshot: DataSnapshot) {
        let value = snapshot.value as! [String: Any]
        self.locationName = value["locationName"] as! String;
        self.line1 = value["line1"] as! String;
        self.line2 = value["line2"] as! String;
        self.line3 = value["line3"] as! String;
        self.city = value["city"] as! String;
        self.state = value["state"] as! String;
        self.zip = value["zip"] as! String;
    }
    
    init(snapshot: QueryDocumentSnapshot) {
        let value = snapshot.data();
        self.locationName = value["locationName"] as! String;
        self.line1 = value["line1"] as! String;
        self.line2 = value["line2"] as! String;
        self.line3 = value["line3"] as! String;
        self.city = value["city"] as! String;
        self.state = value["state"] as! String;
        self.zip = value["zip"] as! String;
    }
    
    init(value: [String: Any])
    {
        self.locationName = value["locationName"] as! String;
        self.line1 = value["line1"] as! String;
        self.line2 = value["line2"] as! String;
        self.line3 = value["line3"] as! String;
        self.city = value["city"] as! String;
        self.state = value["state"] as! String;
        self.zip = value["zip"] as! String;
    }
    
    init(_ address: String)
    {
        self.line1 = "";
        self.city = "";
        self.state = "";
        self.zip = "";
        self.line2 = "";
        self.line3 = "";
        self.locationName = "";
        let tokens = address.components(separatedBy: ",");
        for i in 0..<tokens.count{
            switch(i){
            case 0: self.line1 = tokens[i];
                break;
            case 1: self.city = tokens[i];
                break;
            case 2: let new = tokens[2].components(separatedBy: " ");
                for j in 0..<new.count {
                    switch(j){
                    case 1: self.state = new[1];
                    break;
                    case 2: self.zip = new[2];
                    break;
                    default: break;
                    }
                }
                break;
            default: break;
            }
        }
    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] =
            ["locationName": self.locationName, "line1": self.line1, "line2": self.line2, "line3": self.line3,
             "city": self.city, "state": self.state, "zip": zip];
        return dict;
    }
    
    func toString() -> String {
        let str = "\(self.line1) \(self.line2) \(self.line3), \(self.city), \(self.state) \(self.zip)";
        return str;
    }
}

extension Address: Decodable
{
    // declaring our keys
    enum AddressKeys: String, CodingKey
    {
        case locationName = "locationName";
        case line1 = "line1";
        case line2 = "line2";
        case line3 = "line3";
        case city = "city";
        case state = "state";
        case zip = "zip";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: AddressKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.locationName = try container.decode(String.self, forKey: .locationName);
        } catch {
            self.locationName = "";
        }
        do{
            self.line1 = try container.decode(String.self, forKey: .line1);
        } catch {
            self.line1 = "";
        }
        do{
            self.line2 = try container.decode(String.self, forKey: .line2);
        } catch {
            self.line2 = "";
        }
        do{
            self.line3 = try container.decode(String.self, forKey: .line3);
        } catch {
            self.line3 = "";
        }
        do{
            self.city = try container.decode(String.self, forKey: .city);
        } catch {
            self.city = "";
        }
        do{
            self.state = try container.decode(String.self, forKey: .state);
        } catch {
            self.state = "";
        }
        do{
            self.zip = try container.decode(String.self, forKey: .zip);
        } catch {
            self.zip = "";
        }
    }
}
