//
//  SignInPatientViewModel.swift
//  Deneme4
//
//  Created by Eren on 18.06.2024.
//

import Foundation
import Firebase

class SignInPatientViewModel: ObservableObject {
    @Published var tcNo: String = ""
    @Published var fetchedPatient: Patient? = nil
    
    func fetchPatientInfo() async throws {
        let db = Firestore.firestore()
        let ref = db.collection("Patients").whereField("tcNo", isEqualTo: tcNo)
        
        let snapshot = try await ref.getDocuments()
        guard let document = snapshot.documents.first else {
            throw NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Patient not found"])
        }
        
        let data = document.data()
        let documentID = document.documentID
        let patientName = data["name"] as? String ?? ""
        let patientGenderString = data["gender"] as? String ?? ""
        let patientGender = Patient.General.Gender(rawValue: patientGenderString) ?? .Erkek
        let patientBirthdate = (data["birthdate"] as? Timestamp)?.dateValue() ?? Date()
        let patientTcNo = data["tcNo"] as? String ?? ""
        
        let patient = Patient(
            id: UUID(),
            documentID: documentID,
            general: Patient.General(
                name: patientName,
                gender: patientGender,
                birthdate: patientBirthdate,
                tcNo: patientTcNo
            ),
            contact: Patient.Contact(
                phoneNumber: data["phoneNumber"] as? String ?? "",
                email: data["email"] as? String ?? ""
            ),
            emergency: Patient.Emergency(
                isEmergency: data["isEmergency"] as? Bool ?? false,
                emergencyName: data["emergencyName"] as? String ?? "",
                emergencyNo: data["emergencyNo"] as? String ?? ""
            )
        )
        
        DispatchQueue.main.async {
            self.fetchedPatient = patient
        }
    }
}
