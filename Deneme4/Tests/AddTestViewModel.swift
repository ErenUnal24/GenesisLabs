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
    @Published var patientTCNo: String = ""  // Kullanıcının girdiği TC kimlik numarasını saklayacak
    @Published var patientExists: Bool = false  // Hastanın var olup olmadığını kontrol etmek için

    
    var isValid: Bool {
            !patientTCNo.isEmpty && newTest.patient.general.tcNo == patientTCNo
        //        return !patientTCNo.isEmpty && newTest.testType.testType != .seciniz && newTest.sampleType.sampleType != .seciniz

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
                
                guard let documents = snapshot?.documents, /*!documents.isEmpty*/ let document = documents.first else {
                    self.patientExists = false
                    return
                }
            
                let data = document.data()
                            let patient = Patient(
                                id: UUID(),
                                documentID: document.documentID,
                                general: Patient.General(
                                    name: data["name"] as? String ?? "",
                                    gender: Patient.General.Gender(rawValue: data["gender"] as? String ?? "") ?? .Erkek,
                                    birthdate: (data["birthdate"] as? Timestamp)?.dateValue() ?? Date(),
                                    tcNo: self.patientTCNo
                                ),
                                contact: Patient.Contact(
                                    phoneNumber: data["phoneNumber"] as? String ?? "",
                                    email: data["email"] as? String ?? ""
                                ),
                                emergency: Patient.Emergency(
                                    isEmergency: data["isEmergency"] as? Bool ?? false,
                                    notes: data["emergencyNotes"] as? String ?? ""
                                )
                            )
                            
                            DispatchQueue.main.async {
                                self.newTest = Test(
                                    id: UUID(),
                                    documentID: nil,
                                    patient: patient,
                                    status: Test.Status(status: .numuneBekliyor),
                                    testType: Test.TestType(testType: .seciniz),
                                    sampleType: Test.SampleType(sampleType: .seciniz),
                                    parameters: [:] // Yeni alanın başlangıç değeri

                                )
                                self.patientExists = true
                            }
            }
        }
  
    /*
    func saveTest() {
            newTest.patient.general.tcNo = patientTCNo
            
            // Add default parameters based on test type
            let requiredParameters = newTest.testType.testType.requiredParameters
            for param in requiredParameters {
                newTest.parameters[param] = "0"
            }

            if newTest.documentID == nil {
                dataManager.addTest(newTest)
            } else {
                dataManager.updateTestWithParameters(newTest)
            }
        }
   */
    func saveTest() {
        dataManager.addTest(newTest)
    }
    
    
    
     
    func deleteTest() {
        dataManager.deleteTest(newTest)
    }

}


