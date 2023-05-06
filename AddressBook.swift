//
//  AddressBook.swift
//  iOS3-Lippold-Decken
//
//  Created by  on 23.11.22.
//

import Foundation

class AddressBook: Codable{
    var adressCards: [AddressCard] = []
    
    func add(card: AddressCard){
        adressCards.append(card)
        sort()
    }
    
    func remove(card: AddressCard){
        for otherCard in adressCards{
            otherCard.remove(friend: card)
        }
        if let index = adressCards.firstIndex(of: card){
            adressCards.remove(at: index)
        }
    }
    
    func sort(){
        adressCards.sort(by: {$0.nachname < $1.nachname})
    }
    
    func find(nachname: String) -> [AddressCard]{
        var adressCardArray: [AddressCard] = []
        
        for card in adressCards{
            if(card.nachname == nachname){
                adressCardArray.append(card)
            }
        }
        
        return adressCardArray
    }
    
    func find(id: UUID) -> AddressCard?{
        for card in adressCards{
            if(card.id == id){
                return card
            }
        }
        return nil
    }
    
    func friendsOf(card: AddressCard) -> [AddressCard]{
        var adressCardArray: [AddressCard] = []
        
        for friendID in card.friendList{
            if let friend = find(id: friendID){
                adressCardArray.append(friend)
            }
        }
        
        return adressCardArray
    }
    
    func save(toFile path: String){
        let url = URL(fileURLWithPath: path)
        
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self){
            try? data.write(to: url)
        }
    }
    
    class func addressBook(fromFile path: String) -> AddressBook?{
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url){
            let decoder = JSONDecoder()
            if let adressbook = try? decoder.decode(AddressBook.self, from: data){
                return adressbook
            }
        }
        return nil
    }
}
