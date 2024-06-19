//
//  SignInPatientViewModel.swift
//  Deneme4
//
//  Created by Eren on 18.06.2024.
//

import Firebase
import SwiftUI

final class SignInPatientViewModel: ObservableObject {
    @Published var tcNo: String = ""
    @Published var patient: Patient?
    
    func signIn() async throws {
        // Firebase sorgulama işlemi: TC Kimlik No'ya göre hasta bilgilerini çek
        let db = Firestore.firestore()
        let patientsRef = db.collection("Patients")
        
        let query = patientsRef.whereField("general.tcNo", isEqualTo: tcNo)
        let snapshot = try await query.getDocuments()
        
        if let document = snapshot.documents.first {
            self.patient = try document.data(as: Patient.self)
        } else {
            // Hasta bulunamadı hatasını fırlat
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Hasta bulunamadı"])
        }
    }

}

