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
    @Published var isTcValid: Bool = false
    @Published var tcErrorMessage: String? = nil

    var isValid: Bool {
        !newPatient.general.name.isEmpty &&
        !newPatient.contact.phoneNumber.isEmpty &&
        !newPatient.general.tcNo.isEmpty &&
        isTcValid
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
    
    func validateAndFormatTCNo(tcNo: String) -> (isValid: Bool, formattedTCNo: String, errorMessage: String?) {
        let filtered = tcNo.filter { "0123456789".contains($0) }
        
        guard filtered.count == 11,
              let firstDigit = filtered.first,
              firstDigit != "0" else {
            return (false, filtered, "Kimlik Numarası Hatalı!")
        }

        let tcDigits = filtered.compactMap { $0.wholeNumberValue }
        
        guard tcDigits.count == 11 else {
            return (false, filtered, "11 Haneli olmalı!")
        }

        let oddSum = tcDigits[0] + tcDigits[2] + tcDigits[4] + tcDigits[6] + tcDigits[8]
        let evenSum = tcDigits[1] + tcDigits[3] + tcDigits[5] + tcDigits[7]

        let tenthDigit = ((oddSum * 7) - evenSum) % 10
        if tenthDigit != tcDigits[9] {
            return (false, filtered, "Kimlik Numarası Hatalı!")
        }

        let totalSum = tcDigits[0...9].reduce(0, +)
        let eleventhDigit = totalSum % 10
        return (eleventhDigit == tcDigits[10], filtered, eleventhDigit == tcDigits[10] ? nil : "Kimlik Numarası Hatalı!")
    }
    
    func checkAndFormatTCNo(tcNo: String) {
        let result = validateAndFormatTCNo(tcNo: tcNo)
        self.newPatient.general.tcNo = result.formattedTCNo
        self.isTcValid = result.isValid
        self.tcErrorMessage = result.errorMessage
    }
}
