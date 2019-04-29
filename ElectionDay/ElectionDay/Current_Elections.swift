//
//  HelperCode.swift
//  ElectionDay
//
//  Created by Austin Marino on 3/20/19.
//  Copyright © 2019 Austin Marino. All rights reserved.
//

import Foundation
import Firebase;

struct CurrentElections
{
    var election: Election;
    var contests: [Contest];
    
    init(election: Election, contests: [Contest])
    {
        self.election = election;
        self.contests = contests;
    }
    init()
    {
        self.election = Election();
        self.contests = [Contest]();
    }
}

extension CurrentElections: Decodable
{
    // declaring our keys
    enum CurrentElectionsKeys: String, CodingKey
    {
        case election = "election";
        case contests = "contests";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CurrentElectionsKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.contests = try container.decode([Contest].self, forKey: .contests);
        }catch{
            self.contests = [Contest]();
        }
        do{
            self.election = try container.decode(Election.self, forKey: .election);
        }catch{
            self.election = Election();
        }
    }
}

struct Election{
    var id: String;
    var name: String;
    var electionDay: String;
    var ocdDivisionId: String;
    
    init(){
        self.id = "";
        self.name = "";
        self.electionDay = "";
        self.ocdDivisionId = "";
    }
    
    init(id: String, name: String, electionDay: String, ocdDivisionId: String)
    {
        self.id = id;
        self.name = name;
        self.electionDay = electionDay;
        self.ocdDivisionId = ocdDivisionId;
    }
    
    init(snapshot: QueryDocumentSnapshot)
    {
        let value = snapshot.data();
        self.id = value["id"] as! String;
        self.name = value["name"] as! String;
        self.electionDay = value["electionDay"] as! String;
        self.ocdDivisionId = value["ocdDivisionId"] as! String;
    }
    
    init(value: [String: Any])
    {
        self.id = value["id"] as! String;
        self.name = value["name"] as! String;
        self.electionDay = value["electionDay"] as! String;
        self.ocdDivisionId = value["ocdDivisionId"] as! String;
    }
    
    func toDict() -> [String: Any] {
        let dict: [String: Any] =
            ["id": self.id, "name": self.name,
             "electionDay": self.electionDay, "ocdDivisionId": self.ocdDivisionId];
        return dict;
    }
}

extension Election: Decodable
{
    // declaring our keys
    enum CurrentElectionsKeys: String, CodingKey
    {
        case id = "id";
        case name = "name";
        case electionDay = "electionDay";
        case ocdDivisionId = "ocdDivisionId";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CurrentElectionsKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.id = try container.decode(String.self, forKey: .id);
        }catch{
            self.id = "";
        }
        do{
            self.name = try container.decode(String.self, forKey: .name);
        }catch{
            self.name = "";
        }
        do{
            self.electionDay = try container.decode(String.self, forKey: .electionDay);
        }catch{
            self.electionDay = "";
        }
        do{
            self.ocdDivisionId = try container.decode(String.self, forKey: .ocdDivisionId);
        }catch{
            self.ocdDivisionId = "";
        }
    }
}

struct Candidate
{
    var name: String;
    var party: String;
    var phone: String;
    var candidateUrls: [String];
    var photoUrl: String;
    var email: String;
    var channels: [Channel] = [Channel]();
    
    init(name: String, party: String, phone: String, candidateUrls: [String],
         photoUrl: String, channels: [Channel], email: String)
    {
        self.name = name;
        self.party = party;
        self.phone = phone;
        self.candidateUrls = candidateUrls;
        self.photoUrl = photoUrl;
        self.email = email;
        self.channels = channels;
    }

    init(snapshot: QueryDocumentSnapshot)
    {
        let value = snapshot.data();
        self.name = value["name"] as! String;
        self.party = value["party"] as! String;
        self.phone = value["phone"] as! String;
        self.candidateUrls = value["candidateUrl"] as! [String];
        self.photoUrl = value["photoUrl"] as! String;
        self.email = value["email"] as! String;
        let channel_list = value["channels"] as! [[String: Any]];
        for val in channel_list{
            self.channels.append(Channel(value: val));
        }
    }
    
    init(value: [String: Any])
    {
        self.name = value["name"] as! String;
        self.party = value["party"] as! String;
        self.phone = value["phone"] as! String;
        self.candidateUrls = value["candidateUrl"] as? [String] ?? [String]();
        self.photoUrl = value["photoUrl"] as! String;
        self.email = value["email"] as! String;
        let channel_list = value["channels"] as! [[String: Any]];
        for val in channel_list{
            self.channels.append(Channel(value: val));
        }
    }
    
    func toDict() -> [String: Any] {
        var channelsDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.channels.count{
            channelsDict.append(self.channels[i].toDict());
        }
        let dict: [String: Any] =
            ["name": self.name, "party": self.party, "phone": self.phone,
             "candidateUrls": self.candidateUrls, "photoUrl": photoUrl,
             "email": self.email, "channels": channelsDict];
        return dict;
    }
}

extension Candidate: Decodable
{
    // declaring our keys
    enum CandidateKeys: String, CodingKey
    {
        case name = "name";
        case party = "party";
        case phone = "phone";
        case candidateUrl = "candidateUrl";
        case photoUrl = "photoUrl";
        case email = "email";
        case channels = "channels";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CandidateKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.name = try container.decode(String.self, forKey: .name);
        } catch {
            self.name = "";
        }
        do{
            self.party = try container.decode(String.self, forKey: .party);
        } catch{
            self.party = "";
        }
        do{
            self.phone = try container.decode(String.self, forKey: .phone);
        } catch{
            self.phone = "";
        }
        do{
            self.photoUrl = try container.decode(String.self, forKey: .photoUrl);
        } catch {
            self.photoUrl = "";
        }
        do{
            self.email = try container.decode(String.self, forKey: .email);
        } catch {
            self.email = "";
        }
        do{
            self.candidateUrls = [String]();
            let candidateUrl: String = try container.decode(String.self, forKey: .candidateUrl);
            self.candidateUrls.append(candidateUrl);
        } catch{
            self.candidateUrls = [String]();
        }
        do{
            self.channels = try container.decode([Channel].self, forKey: .channels);
            //adds all the elected official's twitter, facebook and youtube to their urls field
            for channel in self.channels{
                if let _url = channel.url{
                    self.candidateUrls.append(_url);
                }
            }
        } catch {
            self.channels = [Channel]();
        }
    }
}

struct Contest
{
    var type: String;
    var office: String;
    var level: [String];
    var roles: [String];
    var candidates: [Candidate] = [Candidate]();
    
    init(type: String, office: String, roles: [String],
         level: [String], candidates: [Candidate])
    {
        self.type = type;
        self.office = office;
        self.level = level;
        self.roles = roles;
        self.candidates = candidates
    }
    
    init(snapshot: QueryDocumentSnapshot)
    {
        let value = snapshot.data();
        self.type =  value["type"] as! String;
        self.office = value["office"] as! String;
        self.level = value["level"] as! [String];
        self.roles = value["roles"] as! [String];
        let candidate_list = value["candidates"] as! [[String: Any]];
        for val in candidate_list{
            self.candidates.append(Candidate(value: val));
        }
    }
    
    init(value: [String: Any])
    {
        self.type =  value["type"] as! String;
        self.office = value["office"] as! String;
        self.level = value["level"] as! [String];
        self.roles = value["roles"] as! [String];
        let candidate_list = value["candidates"] as! [[String: Any]];
        for val in candidate_list{
            self.candidates.append(Candidate(value: val));
        }
    }
    
    func toDict() -> [String: Any] {
        var candidatesDict: [[String: Any]] = [[String: Any]]();
        for i in 0..<self.candidates.count{
            candidatesDict.append(self.candidates[i].toDict());
        }
        let dict: [String: Any] =
            ["type": self.type, "roles": self.roles, "level": self.level,
             "office": self.office, "candidates": candidatesDict];
        return dict;
    }
}

extension Contest: Decodable
{
    // declaring our keys
    enum ContestKeys: String, CodingKey
    {
        case type = "type";
        case roles = "roles";
        case office = "office";
        case level = "level";
        case candidates = "candidates";
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContestKeys.self) // defining our (keyed) container
        //extracting the data
        do{
            self.type = try container.decode(String.self, forKey: .type);
        } catch {
            self.type = "";
        }
        do{
            self.roles = try container.decode([String].self, forKey: .roles);
        } catch {
            self.roles = [String]();
        }
        do{
            self.level = try container.decode([String].self, forKey: .level);
        } catch {
            self.level = [String]();
        }
        do{
            self.office = try container.decode(String.self, forKey: .office);
        } catch {
            self.office = "";
        }
        do{
            self.candidates = try container.decode([Candidate].self, forKey: .candidates);
        } catch {
            self.candidates = [Candidate]();
        }
    }
}

/*
 {
 "kind": "civicinfo#voterInfoResponse",
 "election": elections Resource,
 "otherElections": [
 elections Resource
 ],
 "normalizedInput": {
 "locationName": string,
 "line1": string,
 "line2": string,
 "line3": string,
 "city": string,
 "state": string,
 "zip": string
 },
 "pollingLocations": [
 {
     "id": string,
     "address": {
         "locationName": string,
         "line1": string,
         "line2": string,
         "line3": string,
         "city": string,
         "state": string,
         "zip": string
     },
     "notes": string,
     "pollingHours": string,
     "name": string,
     "voterServices": string,
     "startDate": string,
     "endDate": string,
     "sources": [
         {
         "name": string,
         "official": boolean
         }
    ]
    }
 ],
 "earlyVoteSites": [
     {
         "id": string,
         "address": {
         "locationName": string,
         "line1": string,
         "line2": string,
         "line3": string,
         "city": string,
         "state": string,
         "zip": string
     },
     "notes": string,
     "pollingHours": string,
     "name": string,
     "voterServices": string,
     "startDate": string,
     "endDate": string,
     "sources": [
     {
         "name": string,
         "official": boolean
     }
    ]
  }
],
"dropOffLocations": [
     {
     "id": string,
     "address": {
     "locationName": string,
     "line1": string,
     "line2": string,
     "line3": string,
     "city": string,
     "state": string,
     "zip": string
     },
     "notes": string,
     "pollingHours": string,
     "name": string,
     "voterServices": string,
     "startDate": string,
     "endDate": string,
     "sources": [
         {
             "name": string,
             "official": boolean
         }
     ]
  }
],
 "contests": [
 {
 "id": string,
 "type": string,
 "primaryParty": string,
 "electorateSpecifications": string,
 "special": string,
 "ballotTitle": string,
 "office": string,
 "level": [
 string
 ],
 "roles": [
 string
 ],
 "district": {
 "name": string,
 "scope": string,
 "id": string
 },
 "numberElected": long,
 "numberVotingFor": long,
 "ballotPlacement": long,
 "candidates": [
 {
 "name": string,
 "party": string,
 "candidateUrl": string,
 "phone": string,
 "photoUrl": string,
 "email": string,
 "orderOnBallot": long,
 "channels": [
 {
 "type": string,
 "id": string
 }
 ]
 }
 ],
 "referendumTitle": string,
 "referendumSubtitle": string,
 "referendumUrl": string,
 "referendumBrief": string,
 "referendumText": string,
 "referendumProStatement": string,
 "referendumConStatement": string,
 "referendumPassageThreshold": string,
 "referendumEffectOfAbstain": string,
 "referendumBallotResponses": [
 string
 ],
 "sources": [
 {
 "name": string,
 "official": boolean
 }
 ]
 }
 ],
 "state": [
 {
 "id": string,
 "name": string,
 "electionAdministrationBody": {
 "name": string,
 "electionInfoUrl": string,
 "electionRegistrationUrl": string,
 "electionRegistrationConfirmationUrl": string,
 "absenteeVotingInfoUrl": string,
 "votingLocationFinderUrl": string,
 "ballotInfoUrl": string,
 "electionRulesUrl": string,
 "voter_services": [
 string
 ],
 "hoursOfOperation": string,
 "correspondenceAddress": {
 "locationName": string,
 "line1": string,
 "line2": string,
 "line3": string,
 "city": string,
 "state": string,
 "zip": string
 },
 "physicalAddress": {
 "locationName": string,
 "line1": string,
 "line2": string,
 "line3": string,
 "city": string,
 "state": string,
 "zip": string
 },
 "electionOfficials": [
 {
 "name": string,
 "title": string,
 "officePhoneNumber": string,
 "faxNumber": string,
 "emailAddress": string
 }
 ]
 },
 "local_jurisdiction": (AdministrationRegion),
 "sources": [
 {
 "name": string,
 "official": boolean
 }
 ]
 }
 ],
 "mailOnly": boolean
 }
*/

/*
 struct VotingLocations
 {
 var id: String;
 var address: Address;
 var notes: String;
 var pollingHours: String;
 var name: String;
 var voterServices: String;
 var startDate: String;
 var endDate: String;
 
 init(id: String, address: Address, notes: String,
 pollingHours: String, name: String, voterServices: String,
 startDate: String, endDate: String)
 {
 self.id = id;
 self.address = address;
 self.notes = notes;
 self.pollingHours = pollingHours;
 self.name = name;
 self.voterServices = voterServices;
 self.startDate = startDate;
 self.endDate = endDate;
 }
 }
 
 extension VotingLocations: Decodable
 {
 // declaring our keys
 enum VotingLocationsKeys: String, CodingKey
 {
 case id = "id";
 case address = "address";
 case notes = "notes";
 case pollingHours = "pollingHours";
 case name = "name";
 case voterServices = "voterServices";
 case startDate = "startDate";
 case endDate = "endDate";
 }
 
 init(from decoder: Decoder) throws
 {
 let container = try decoder.container(keyedBy: VotingLocationsKeys.self) // defining our (keyed) container
 //extracting the data
 let id = try container.decode(String.self, forKey: .id);
 let address = try container.decode(Address.self, forKey: .address);
 let notes = try container.decode(String.self, forKey: .notes);
 let pollingHours = try container.decode(String.self, forKey: .pollingHours);
 let name = try container.decode(String.self, forKey: .name);
 let voterServices = try container.decode(String.self, forKey: .voterServices);
 let startDate = try container.decode(String.self, forKey: .startDate);
 let endDate = try container.decode(String.self, forKey: .endDate);
 // initializing our struct
 self.init(id: id, address: address, notes: notes,
 pollingHours: pollingHours, name: name, voterServices: voterServices,
 startDate: startDate, endDate: endDate);
 }
 }
 
 struct Candidates
 {
 var name: String;
 var party: String;
 var candidateUrl: String;
 var phone: String;
 var photoUrl: String;
 var email: String;
 var orderOnBallot: Int64;
 
 init(name: String, party: String, candidateUrl: String,
 phone: String, photoUrl: String, email: String, orderOnBallot: Int64)
 {
 self.name = name;
 self.party = party;
 self.candidateUrl = candidateUrl;
 self.phone = phone;
 self.photoUrl = photoUrl;
 self.email = email;
 self.orderOnBallot = orderOnBallot;
 }
 }
 
 extension Candidates: Decodable
 {
 // declaring our keys
 enum CandidatesKeys: String, CodingKey
 {
 case name = "name";
 case party = "party";
 case candidateUrl = "candidateUrl";
 case phone = "phone";
 case photoUrl = "photoUrl";
 case email = "email";
 case orderOnBallot = "orderOnBallot";
 }
 
 init(from decoder: Decoder) throws
 {
 let container = try decoder.container(keyedBy: CandidatesKeys.self); // defining our (keyed) container
 //extracting the data
 let name = try container.decode(String.self, forKey: .name);
 let party = try container.decode(String.self, forKey: .party);
 let candidateUrl = try container.decode(String.self, forKey: .candidateUrl);
 let phone = try container.decode(String.self, forKey: .phone);
 let photoUrl = try container.decode(String.self, forKey: .photoUrl);
 let email = try container.decode(String.self, forKey: .email);
 let orderOnBallot = try container.decode(Int64.self, forKey: .orderOnBallot);
 // initializing our struct
 self.init(name: name, party: party, candidateUrl: candidateUrl,
 phone: phone, photoUrl: photoUrl, email: email, orderOnBallot: orderOnBallot);
 }
 }
 */
