//
//  AddTestViewModel.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Foundation
import Firebase

final class AddTestViewModel: ObservableObject {
    
    var dataManager = TestDataManager()
    
    @Published var newTest: Test = .emptyTest
    @Published var patientTCNo: String = ""  // Kullanıcının girdiği TC kimlik numarasını saklayacak değişken
    @Published var patientExists: Bool = false  // Hastanın var olup olmadığını kontrol etmek için

    
    var isValid: Bool {
            !patientTCNo.isEmpty && newTest.patient.general.tcNo == patientTCNo
        }
    
    func clearAll() {
        self.newTest = .emptyTest
        self.patientTCNo = ""
        self.patientExists = false

    }
    
    //***
    func fetchPatientByTCNo() {
            let db = Firestore.firestore()
            let ref = db.collection("Patients").whereField("tcNo", isEqualTo: patientTCNo)
            ref.getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching patient: \(error)")
                    self.patientExists = false
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    self.patientExists = false
                    return
                }
                
                if let document = documents.first {
                    let data = document.data()
                    let id = UUID()
                    let name = data["name"] as? String ?? ""
                    let genderString = data["gender"] as? String ?? ""
                    let gender = Patient.General.Gender(rawValue: genderString) ?? .Erkek
                    let birthdate = (data["birthdate"] as? Timestamp)?.dateValue() ?? Date()
                    let phoneNumber = data["phoneNumber"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                 //   let testTypeString = data["testType"] as? String ?? ""
                 //   let testType = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                    let isEmergency = data["isEmergency"] as? Bool ?? false
                    let emergencyNotes = data["emergencyNotes"] as? String ?? ""
                    
                    let patient = Patient(
                        id: id,
                        documentID: document.documentID,
                        general: Patient.General(name: name, gender: gender, birthdate: birthdate, tcNo: self.patientTCNo),
                        contact: Patient.Contact(phoneNumber: phoneNumber, email: email),
                      //  testType: Patient.TestType(testType: testType),
                        emergency: Patient.Emergency(isEmergency: isEmergency, notes: emergencyNotes)
                       // status: Test.Status(status: status)
                    )
                    
                    DispatchQueue.main.async {
                        self.newTest = Test(id: UUID(), documentID: nil, patient: patient, status: Test.Status(status: .numuneBekliyor), testType: Test.TestType(testType: .seciniz), sampleType: Test.SampleType(sampleType: .seciniz))
                        self.patientExists = true
                    }
                }
            }
        }
    //***
    
    //**
    
    //**
    
    
    func saveTest() {
        newTest.patient.general.tcNo = patientTCNo
        dataManager.addTest(newTest)
    }
    
    /*
    func editTest() {
        dataManager.updateTest(newTest)
    }
    */
     
    func deleteTest() {
        dataManager.deleteTest(newTest)
    }

}

// Test struct'ına uygun bir emptyTest eklentisi
/*
extension Test {
    static var emptyTest: Test {
        let general = Patient.General(
            name: "",
            gender: .Erkek,
            birthdate: Date(),
            tcNo: ""
        )
        
        let contact = Patient.Contact(
            phoneNumber: "",
            email: ""
        )
        
        let emergency = Patient.Emergency(
            isEmergency: false,
            notes: ""
        )
        
        let testType = Patient.TestType(
            testType: .ces
        )
        
        let patient = Patient(
            id: UUID(),
            documentID: nil,
            general: general,
            contact: contact,
            testType: testType,
            emergency: emergency
        )
        
        return Test(
            id: UUID(),
            documentID: nil,
            patient: patient,
            status: Test.Status.StatusEnum
        )
    }
}


*/
