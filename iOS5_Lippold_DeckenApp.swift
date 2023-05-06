//
//  iOS5_Lippold_DeckenApp.swift
//  iOS5-Lippold_Decken
//
//  Created by  on 04.01.23.
//

import SwiftUI

@main
struct iOS5_Lippold_DeckenApp: App {
    @Environment(\.scenePhase) private var scenePhase
    var contactsViewModel = ContactsViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContactsView(contactsViewModel : contactsViewModel)
                .onChange(of: scenePhase){ phase in
                    if phase == .inactive {
                        contactsViewModel.saveModel()
                    }
                }
        }
    }
}
