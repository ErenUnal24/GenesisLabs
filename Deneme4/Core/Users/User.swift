//
//  User.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    let documentID: String?
    var general: General
    var userType: UserType
}

extension User {
    struct General: Codable {
        var name: String
        var email: String
    }
}

extension User {
    struct UserType: Codable {
        var userType: UserTypeEnum
    }
}

extension User.UserType {
    enum UserTypeEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
       
        case danisma = "Danışma"
        case numuneKabul = "Numune Kabul"
        case laborant = "Laborant"
        case biyolog = "Biyolog"
        case uzman = "Uzman"
        case admin = "admin"
    }
}

extension User {
    static var emptyUser: User {
        let general = User.General(name: "", email: "")
        let userType = User.UserType(userType: UserType.UserTypeEnum.allCases.first!)
        return User(id: UUID(), documentID: nil, general: general, userType: userType)
    }
}
