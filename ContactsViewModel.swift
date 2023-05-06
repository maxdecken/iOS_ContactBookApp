//
//  ContactsViewModel.swift
//  iOS5-Lippold_Decken
//
//  Created by  on 04.01.23.
//

import Foundation
import SwiftUI
import Combine

class ContactsViewModel: ObservableObject {
    @Published private var addressbookModel = AddressBook()
    var objectWillChange = ObservableObjectPublisher()
    
    init(){
        loadModel()
    }
    
    var addressBook: AddressBook {
        get{
            return addressbookModel
        }
    }
    
    var addressCards: [AddressCard] {
        get{
            return addressbookModel.adressCards
        }
        set{
            addressbookModel.adressCards = newValue
            updateView()
        }
    }
    
    func getAddressCard(addressCard: AddressCard) -> AddressCard{
        if let _card = addressBook.find(id: addressCard.id){
            return _card
        }else{
            return AddressCard()
        }
    }
    
    func addContact(vorname : String, nachname : String, strasse : String, plz : String, ort : String){
        let newCard = AddressCard()
        newCard.vorname = vorname
        newCard.nachname = nachname
        newCard.strasse = strasse
        if let _plz = Int(plz){
            newCard.plz = _plz
        }
        newCard.ort = ort
        addressbookModel.add(card: newCard)
        updateView()
    }
    
    func updateView(){
        objectWillChange.send()
    }
    
    func loadModel(){
        if let _addressbook = AddressBook.addressBook(fromFile: "book.json"){
            addressbookModel = _addressbook
        }else{
            addressbookModel = AddressBook()
            fillAddressBook(adressbook: addressbookModel)
        }
    }
    
    func saveModel(){
        addressbookModel.save(toFile: "book.json")
    }
    
    func fillAddressBook(adressbook: AddressBook){
        let ben = AddressCard()
        ben.vorname = "Ben"
        ben.nachname = "Lippold"
        ben.strasse = "Gehainstraße 4"
        ben.plz = 12439
        ben.ort = "Berlin"
        ben.add(hobby: Hobby(hobbyName: "spazieren"))
        ben.add(hobby: Hobby(hobbyName: "sitzen"))
        addressbookModel.add(card: ben)
        
        let max = AddressCard()
        max.vorname = "Max"
        max.nachname = "Decken"
        max.strasse = "Gecauerstraße 22"
        max.plz = 10587
        max.ort = "Berlin"
        max.add(hobby: Hobby(hobbyName: "essen"))
        max.add(hobby: Hobby(hobbyName: "musik hören"))
        addressbookModel.add(card: max)
        
        let guido = AddressCard()
        guido.vorname = "Guido"
        guido.nachname = "von der Ecke"
        guido.strasse = "Geheimstraße -1"
        guido.plz = 00007
        guido.ort = "Geheim"
        guido.add(hobby: Hobby(hobbyName: "geheim sein"))
        guido.add(hobby: Hobby(hobbyName: "james bond filme"))
        addressbookModel.add(card: guido)
    }
}

