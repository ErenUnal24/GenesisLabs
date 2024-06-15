//
//  NewPatient.swift
//  Deneme4
//
//  Created by Eren on 2.06.2024.
//

import Foundation

struct Patient: Identifiable, Codable {
    let id: UUID
    let documentID: String?
    var general: General
    var contact: Contact
 
    var emergency: Emergency
    
   
}


extension Patient {
    struct General: Codable{
        var name     : String
        var gender   : Gender
        var birthdate: Date
        var tcNo     : String
    }
}

extension Patient.General {
    enum Gender: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case Erkek
        case Kadın
        case Diğer
    }
}

extension Patient {
    struct Contact: Codable {
        var phoneNumber: String
        var email      : String
    }
}

extension Patient {
    struct Emergency: Codable {
        var isEmergency: Bool
        var notes      : String
    }
}




extension Patient {
    static var emptyPatient: Patient {
        let general = Patient.General(     name: "",
                                            gender: Patient.General.Gender.allCases.first!,
                                         birthdate: Date(),
                                              tcNo: "")
        
        let contact = Patient.Contact(phoneNumber: "",
                                            email: "")
        
        let emergency = Patient.Emergency(isEmergency: false,
                                                notes: "")
        
        
        return Patient(id: UUID(), documentID: nil, general: general, contact: contact, emergency: emergency)
      
    }
}
