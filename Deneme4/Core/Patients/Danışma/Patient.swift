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
   // var testType: TestType
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


/*
extension Patient {
    struct TestType: Codable {
        var testType: TestTypeEnum
        
    }
}

extension Patient.TestType {
    enum TestTypeEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case ces = "Klinik Ekzom Dizileme"
        case tekgen  = "Tek Gen Dizi Analizi"
        case cftr = "CFTR Dizi Analizi"
        case smn1 = "SMN1-2 Delesyon Duplikasyon Analizi"
        case kalıtsalkanser = "Kalıtsal Kanser Paneli"
        case hiperamoni = "Hiperamonemi Gen Paneli"


    }
}

*/

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
        
   //     let testType = Patient.TestType(testType: Patient.TestType.TestTypeEnum.allCases.first!)
        
        return Patient(id: UUID(), documentID: nil, general: general, contact: contact,/* testType: testType,*/ emergency: emergency)
      
    }
}
