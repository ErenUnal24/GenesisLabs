//
//  User.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation


struct Users: Identifiable, Codable {
    let id: UUID
    let documentID: String?
    var general: General
    var userType: UserType
    
    
    
}



extension Users {
    struct General: Codable {
        var name : String
        var email: String
    }
}

extension Users {
    struct UserType: Codable {
        var userType : UserTypeEnum
    }
}

extension Users.UserType {
    enum UserTypeEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case admin = "admin"
        case danisma = "Danışma"
        case numuneKabul = "Numune Kabul"
        case labaratuar = "Labaratuar"
        case analiz = "Analiz"
        case biyolog = "biyolog"
    }
}



extension Users {
    static var emptyUser: Users {
        let general = Users.General(name: "", email: "")
        let userType = Users.UserType(userType: UserType.UserTypeEnum.allCases.first!)
        
        return Users(id: UUID(), documentID: nil, general: general, userType: userType)
    }
}
