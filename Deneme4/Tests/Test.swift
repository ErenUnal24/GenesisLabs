//
//  Test.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation


struct Test: Identifiable, Codable {
    let id: UUID
    let documentID: String?
    var patient: Patient
    var status : Status
    var testType: TestType
    var tcNo: String {
        return patient.general.tcNo
    }
    var sampleType: SampleType
    
    var parameters: [String: String] = [:] //yeni ekledim
    
    var analysis: String?
    
}



extension Test {
    struct TestType: Codable {
        var testType: TestTypeEnum
        
    }
}

extension Test.TestType {
    enum TestTypeEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case seciniz = "Seçiniz"
        case ces = "Klinik Ekzom Dizileme"
        case tekgen  = "Tek Gen Dizi Analizi"
        case cftr = "CFTR Dizi Analizi"
        case smn1 = "SMN1-2 Delesyon Duplikasyon Analizi"
        case kalitsalkanser = "Kalıtsal Kanser Paneli"
        case hiperamoni = "Hiperamonemi Gen Paneli"
        
        var requiredParameters: [String] {
            switch self {
            case .ces, .tekgen, .cftr, .kalitsalkanser, .hiperamoni:
                            return ["gen", "ref", "varyant", "alt", "vf"]
                        case .smn1:
                            return ["gen", "exon", "Kopya Sayısı"]
                        default:
                            return []
                        }
        }
    }
}


 
extension Test {
    struct SampleType: Codable {
        var sampleType: SampleTypeEnum
        
    }
}

extension Test.SampleType {
    enum SampleTypeEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case seciniz = "Seçiniz"
        case periferik = "Periferik Kan"
        case ilik  = "Kemik İliği"
        case amniyon = "Amniyon Sıvısı"
        case abort = "Abort Materyali"
    }
}


     
extension Test {
    struct Status: Codable {
        var status: StatusEnum
    }
}

extension Test.Status {
    enum StatusEnum: String, Identifiable, CaseIterable, Codable {
        var id: Self { self }
        case numuneBekliyor  = "Numune Bekliyor"
        case testBekliyor    = "Test Bekliyor"
        case analizBekliyor  = "Analiz Bekliyor"
        case raporBekliyor   = "Rapor Bekliyor"
        case raporlandi      = "Rapor Oluştu"
    }
}





extension Test {
    static var emptyTest: Test {
        let emptyPatient = Patient.emptyPatient
        let status = Test.Status(status: .numuneBekliyor)
        let testType = Test.TestType(testType: Test.TestType.TestTypeEnum.allCases.first!)
        let sampleType = Test.SampleType(sampleType: Test.SampleType.SampleTypeEnum.allCases.first!)
        
        
        
        return Test(id: UUID(), documentID: nil, patient: emptyPatient, status: status, testType: testType, sampleType: sampleType)

    }
}
