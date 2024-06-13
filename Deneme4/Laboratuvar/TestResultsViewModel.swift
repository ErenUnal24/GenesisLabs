//
//  TestResultsViewModel.swift
//  Deneme4
//
//  Created by Eren on 12.06.2024.
//

import Foundation
import Combine
import FirebaseFirestore

final class TestResultsViewModel: ObservableObject {
    @Published var test: Test
    @Published var parameterValues: [String: String] = [:]
    var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []

    
    
    init(test: Test, dataManager: TestDataManager) {
            self.test = test
            self.dataManager = dataManager

            // Test türüne göre gerekli parametreleri ayarla
            updateRequiredParameters()
            fetchTestParameters()
        }
     
     
    init(test: Test, parameterValues: [String: String], dataManager: TestDataManager) {
           self.test = test
           self.parameterValues = parameterValues
           self.dataManager = dataManager
       }
     
    
    func updateRequiredParameters() {
            parameterValues = [:]
            for parameter in test.testType.testType.requiredParameters {
                parameterValues[parameter] = ""
            }
        }
     
     
    
    func fetchTestParameters() {
            let db = Firestore.firestore()
            let ref = db.collection("Tests").document(test.documentID ?? "")
            
            ref.getDocument { document, error in
                if let document = document, document.exists {
                    if let data = document.data(), let parameters = data["parameters"] as? [String: String] {
                        DispatchQueue.main.async {
                            self.parameterValues = parameters
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    
     
     
    
    private func setupParameters() {
        switch test.testType.testType {
        case .ces, .tekgen, .cftr, .kalitsalkanser, .hiperamoni:
            parameterValues = ["gen": "", "ref": "", "varyant": "", "alt": "", "vf": ""]
        case .smn1:
            parameterValues = ["gen1": "", "ref1": "", "varyant1": "", "alt1": "", "vf1": ""]
        default:
            parameterValues = [:]
        }
    }
    
    
   
    
    
    
    func saveTestResults() {
           test.parameters = self.parameterValues
          // dataManager.updateTestWithParameters(test)
        dataManager.saveTestResults(test: test, parameterValues: parameterValues)
       }
    
    /*
    func saveTestResults() {
            dataManager.saveTestResults(test: test, parameterValues: parameterValues)
        }
    */
}
