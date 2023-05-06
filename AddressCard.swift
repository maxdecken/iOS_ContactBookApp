//
//  AddressCard.swift
//  iOS3-Lippold-Decken
//
//  Created by  on 23.11.22.
//

import Foundation

class AddressCard: Identifiable, Codable, Equatable, Hashable{
    var id = UUID()
    var vorname = ""
    var nachname = ""
    var strasse = ""
    var plz: Int = 0
    var ort = ""
    var hobbyList: [Hobby] = []
    var friendList: [UUID] = []
    
    static func == (lhs: AddressCard, rhs: AddressCard) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    func add(hobby: Hobby){
        hobbyList.append(hobby)
    }
    
    func remove(hobby: Hobby){
        if let index = hobbyList.firstIndex(of: hobby){
            hobbyList.remove(at: index)
        }
    }
    
    func add(friend: AddressCard){
        friendList.append(friend.id)
    }
    
    func remove(friend: AddressCard){
        if let index = friendList.firstIndex(of: friend.id){
            friendList.remove(at: index)
        }
    }
}
