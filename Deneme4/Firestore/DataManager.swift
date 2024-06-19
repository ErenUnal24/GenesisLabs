//
//  DataManager.swift
//  Deneme4
//
//  Created by Eren on 5.06.2024.
//

import SwiftUI
import Firebase

class DataManager: ObservableObject {
    @Published var patients: [Patient] = []
    //@Published var testResults: [TestResult] = []

    
    
    func fetchPatients() {
        patients.removeAll()
        let db  = Firestore.firestore()
        let ref = db.collection("Patients")
        ref.getDocuments{ snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                                        let documentID         = document.documentID
                                        let tcNo               = data["tcNo"] as? String ?? ""
                                        let name               = data["name"] as? String ?? ""
                                        let genderString       = data["gender"] as? String ?? ""
                                        let gender             = Patient.General.Gender(rawValue: genderString) ?? .Diğer
                                        let birthDate          = (data["birthDate"] as? Timestamp)?.dateValue() ?? Date()
                                        let phoneNumber        = data["phoneNumber"] as? String ?? ""
                                        let email              = data["email"] as? String ?? ""
                                  //      let testTypeString     = data["testType"] as? String ?? ""
                                 //       let testType           = Patient.TestType.TestTypeEnum(rawValue: testTypeString) ?? .ces
                                        let isEmergency        = data["isEmergency"] as? Bool ?? false
                                        let emergencyName     = data["emergencyNotes"] as? String ?? ""
                                        let emergencyNo     = data["emergencyNo"] as? String ?? ""

                             
                                        
                                        let patient = Patient(
                                                    id: UUID(),
                                            documentID: documentID,
                                               general: Patient.General(               name: name,
                                                                                          gender: gender,
                                                                                          birthdate: birthDate,
                                                                                          tcNo: tcNo),
                                            
                                               contact: Patient.Contact(               phoneNumber: phoneNumber,
                                                                                          email: email),
                                            
                                            /*  testType: Patient.TestType(              testType: testType),  */
                                            
                                             emergency: Patient.Emergency(             isEmergency: isEmergency,
                                                                                       emergencyName: emergencyName, emergencyNo: emergencyName)
                                            
                                            
                                  //          sampleStatus: NewPatient.SampleStatus(       sampleStatus: sampleStatus),
                                            
                                    //        testResults: NewPatient.TestResults(          demir: demir,
                                      //                                                    dVit: dVit,
                                        //                                                  colesterol: colesterol)
                                            
                                        )
                                        
                    
                    
                    
                                        DispatchQueue.main.async {
                                            self.patients.append(patient)
                                        }
                                    }
                                }
                            }
                        }
    
    
    
    
    func addPatient(_ patient: Patient) {
        let db = Firestore.firestore()
        db.collection("Patients").addDocument(data: [
            "name": patient.general.name,
            "tcNo": patient.general.tcNo,
            "gender": patient.general.gender.rawValue,
            "birthdate": patient.general.birthdate,
            "phoneNumber": patient.contact.phoneNumber,
            "email": patient.contact.email,
         //   "testType": patient.testType.testType.rawValue,
            "isEmergency": patient.emergency.isEmergency,
            "emergencyName": patient.emergency.emergencyName,
            "emergencyNo": patient.emergency.emergencyNo,

 
        ]) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                
            }
        }
    }
    
    
    func updatePatient(_ patient: Patient) {
        guard let documentID = patient.documentID else {
                print("Document ID is nil")
                return
            }
            
            let db = Firestore.firestore()
            db.collection("Patients").document(documentID).updateData([
                "name": patient.general.name,
                "tcNo": patient.general.tcNo,
                "gender": patient.general.gender.rawValue,
                "birthdate": patient.general.birthdate,
                "phoneNumber": patient.contact.phoneNumber,
                "email": patient.contact.email,
            //    "testType": patient.testType.testType.rawValue,
                "isEmergency": patient.emergency.isEmergency,
                "emergencyName": patient.emergency.emergencyName,
                "emergencyNo": patient.emergency.emergencyNo,

    
            ]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated successfully")
                }
            }
        }
    
    
    
    func deletePatient(_ patient: Patient) {
        guard let documentID = patient.documentID else {
                print("Document ID is nil")
                return
            }
        let db = Firestore.firestore()
            db.collection("Patients").document(documentID).delete 
            { error in
                if let error = error {
                    print("Error deleting patient: \(error)")
                    
                } else {
                    print("Patient deleted successfully")
                }
            }
        }
    
    
    
    
     
}
