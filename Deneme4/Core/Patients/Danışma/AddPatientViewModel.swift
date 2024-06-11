//
//  AddPatientsViewModel.swift
//  Deneme4
//
//  Created by Eren on 2.06.2024.
//

import Foundation

final class AddPatientViewModel: ObservableObject {
    
    var dataManager = DataManager()
    
    @Published var newPatient: Patient = .emptyPatient
    
    var isValid: Bool {
        !newPatient.general.name.isEmpty &&
        !newPatient.contact.phoneNumber.isEmpty &&
        !newPatient.general.tcNo.isEmpty
    }
    
    func clearAll() {
        self.newPatient = .emptyPatient
    }    
    
    
    func savePatient() {
        dataManager.addPatient(newPatient)
    }
    
    func editPatient() {
        dataManager.updatePatient(newPatient)
    }
    
    func deletePatient() {
            dataManager.deletePatient(newPatient)
            
        }

}
