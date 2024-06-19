//
//  PatientDetailViewModel.swift
//  GeneSys
//
//  Created by Eren on 19.06.2024.
//

import SwiftUI
import Firebase

final class PatientDetailViewModel: ObservableObject {
    @Published var tests: [Test] = []
    
    func fetchTests(for tcNo: String) {
        let db = Firestore.firestore()
        let testsRef = db.collection("Tests")
        
        testsRef.whereField("patient.general.tcNo", isEqualTo: tcNo).getDocuments { [self] snapshot, error in
            guard error == nil else {
                print("Error fetching tests: \(error!.localizedDescription)")
                return
            }
            
            if let snapshot = snapshot {
                let fetchedTests = snapshot.documents.compactMap { document -> Test? in
                    let data = document.data()
                    let documentID = document.documentID
                    
                    guard let testTypeString = data["testType.testType"] as? String,
                          let testType = Test.TestType.TestTypeEnum(rawValue: testTypeString),
                          let pdfURLString = data["pdfURL"] as? String,
                          let pdfURL = URL(string: pdfURLString) else {
                        return nil
                    }
                    
                    return Test(
                        id: UUID(),
                        documentID: documentID,
                        patient: patientFromData(data),
                        status: Test.Status(status: .numuneBekliyor), // Adjust as necessary
                        testType: Test.TestType(testType: testType),
                        sampleType: Test.SampleType(sampleType: .seciniz) // Adjust as necessary
                       // pdfURL: pdfURL
                    )
                }
                
                DispatchQueue.main.async {
                    self.tests = fetchedTests
                }
            }
        }
    }
    
    private func patientFromData(_ data: [String: Any]) -> Patient {
        // Implement a method to convert Firestore data to a Patient object
        // Adjust the fields as necessary to match your data structure
        return Patient(
            id: UUID(),
            documentID: data["documentID"] as? String ?? "",
            general: Patient.General(
                name: data["general.name"] as? String ?? "",
                gender: .Erkek, // Adjust as necessary
                birthdate: Date(), // Adjust as necessary
                tcNo: data["general.tcNo"] as? String ?? ""
            ),
            contact: Patient.Contact(
                phoneNumber: data["contact.phoneNumber"] as? String ?? "",
                email: data["contact.email"] as? String ?? ""
            ),
            emergency: Patient.Emergency(
                isEmergency: data["emergency.isEmergency"] as? Bool ?? false,
                emergencyName: data["emergency.emergencyName"] as? String ?? "",
                emergencyNo: data["emergency.emergencyNo"] as? String ?? ""

            )
        )
    }
}
