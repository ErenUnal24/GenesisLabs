//
//  UpdateTestViewModel.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//

import Firebase

final class UpdateTestViewModel: ObservableObject {
    
    var dataManager = TestDataManager()
    
    @Published var tests: [Test] = []

    
    @Published var newTest: Test = .emptyTest
    @Published var patientTCNo: String = ""  // Kullanıcının girdiği TC kimlik numarasını saklayacak değişken
    @Published var patientExists: Bool = false  // Hastanın var olup olmadığını kontrol etmek için
    
    //**
    var dm = AddTestViewModel()
    //**

    
    var isValid: Bool {
            !patientTCNo.isEmpty && newTest.patient.general.tcNo == patientTCNo
        }
    
    func clearAll() {
        self.newTest = .emptyTest
        self.patientTCNo = ""
        self.patientExists = false

    }

    
    func saveTest() {
        newTest.patient.general.tcNo = patientTCNo
        dataManager.addTest(newTest)
        
    }
    
    
    func editTest() {
        dataManager.updateTest(newTest)
    }
    
     
    func deleteTest() {
        dataManager.deleteTest(newTest)
    }

}
