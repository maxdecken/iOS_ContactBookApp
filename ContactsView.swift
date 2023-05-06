//
//  ContactsView.swift
//  iOS5-Lippold_Decken
//
//  Created by  on 04.01.23.
//

import SwiftUI

struct ContactsView: View {
    @ObservedObject var contactsViewModel: ContactsViewModel
    var body: some View {
        NavigationView{
            List{
                ForEach(contactsViewModel.addressCards){card in
                    NavigationLink {
                        ContactDetail(card: card, addressbook: contactsViewModel.addressBook)
                            .environmentObject(contactsViewModel)
                    } label: {
                        Text(card.vorname + " " + card.nachname)
                    }
                }
                .onDelete{ indexSet in
                    contactsViewModel.addressCards.remove(atOffsets: indexSet)
                }
            }
            .navigationTitle("Contacts")
            .toolbar{
                toolbarItems
            }
        }
    }
    
    @ToolbarContentBuilder var toolbarItems: some ToolbarContent {
        ToolbarItem{
            EditButton()
        }
        ToolbarItem(placement: .navigationBarLeading){
            NavigationLink{
                AddContactView { vorname, nachname, strasse, plz, ort in
                    contactsViewModel.addContact(vorname : vorname, nachname: nachname, strasse : strasse, plz : plz, ort : ort)
                }
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

struct ContactDetail : View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    var card : AddressCard
    var addressbook: AddressBook
    
    var cardIndex: Int {
        contactsViewModel.addressCards.firstIndex(of: card) ?? 0
    }
    
    var body : some View {
        VStack {
            List{
                Section(header: Text("Info")){
                    TextEditor(text: $contactsViewModel.addressCards[cardIndex].strasse)
                    Text(String(contactsViewModel.addressCards[cardIndex].plz))
                    TextEditor(text: $contactsViewModel.addressCards[cardIndex].ort)
                }
                Section(header: Text("Friends")){
                    ForEach(contactsViewModel.addressCards[cardIndex].friendList, id: \.self){ friendID in
                        if let friend = addressbook.find(id: friendID){
                            Text(friend.vorname + friend.nachname)
                        }
                    }
                    .onDelete{ indexSet in
                        contactsViewModel.addressCards[cardIndex].friendList.remove(atOffsets: indexSet)
                    }
                    NavigationLink {
                        AddFriendView { friend in
                            contactsViewModel.addressCards[cardIndex].add(friend: friend)
                        }
                        .environmentObject(contactsViewModel)
                    } label: {
                        Text("Add Friend")
                    }
                }
               
                Section(header: Text("Hobbys")){
                    ForEach(contactsViewModel.addressCards[cardIndex].hobbyList){ hobby in
                        Text(hobby.hobbyName)
                    }
                    .onDelete{ indexSet in
                        //if let index = card.hobbyList.indexOf(hobby)
                        contactsViewModel.addressCards[cardIndex].hobbyList.remove(atOffsets: indexSet)
                    }
                    NavigationLink {
                        AddHobbyView { hobbyName in
                            contactsViewModel.addressCards[cardIndex].add(hobby: Hobby(hobbyName: hobbyName))
                        }
                    } label: {
                        Text("Add Hobby")
                    }
                }
            }
            .navigationTitle(Text(card.vorname + " " + card.nachname))
            .toolbar{
                toolbarItems
            }
        }
    }
    @ToolbarContentBuilder var toolbarItems: some ToolbarContent {
        ToolbarItem{
            EditButton()
        }
    }
}

struct AddContactView : View {
    @State var vorname: String = ""
    @State var nachname: String = ""
    @State var strasse: String = ""
    @State var plz: String = ""
    @State var ort: String = ""
    var completed: (String, String, String, String, String) -> Void
    
    var body: some View{
        Form{
            TextField("Vorname", text: $vorname)
            TextField("nachname", text: $nachname)
            TextField("strasse", text: $strasse)
            TextField("plz", text: $plz)
            TextField("ort", text: $ort)
        }
        .navigationTitle("Add Contact")
        .onDisappear(){
            if (vorname != "") && (nachname != ""){
                completed(vorname, nachname, strasse, plz, ort)
            }
        }
    }
    
}

struct ContactsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactsView(contactsViewModel: ContactsViewModel())
    }
}

struct AddFriendView: View {
    @EnvironmentObject var contactsViewModel: ContactsViewModel
    @State var selectedFriend = AddressCard()
    var completed: (AddressCard) -> Void
    var body: some View {
        Form {
            Picker("Add Friend", selection: $selectedFriend) {
                ForEach(contactsViewModel.addressBook.adressCards, id:\.self) { contact in
                    Text(contact.vorname + " " + contact.nachname)
                }
            }
            .pickerStyle(.inline)
        }
        .navigationTitle("Add Friend")
        .onDisappear {
            completed(selectedFriend)
        }
    }
}

struct AddHobbyView: View {
    @State var enteredHobby: String = ""
    var completed: (String) -> Void
    var body: some View {
        Form {
            TextField("Hobbyname", text: $enteredHobby)
        }
        .navigationTitle("Add Hobby")
        .onDisappear {
            completed(enteredHobby)
        }
    }
}
