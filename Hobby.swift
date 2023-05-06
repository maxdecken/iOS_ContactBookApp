//
//  Hobby.swift
//  iOS3-Lippold-Decken
//
//  Created by  on 23.11.22.
//

import Foundation

class Hobby: Identifiable, Codable, Equatable{
    var id = UUID()
    var hobbyName = ""
    
    init(hobbyName: String){
        self.hobbyName = hobbyName
    }
    
    static func == (lhs: Hobby, rhs: Hobby) -> Bool {
        return lhs.id == rhs.id
    }
}
