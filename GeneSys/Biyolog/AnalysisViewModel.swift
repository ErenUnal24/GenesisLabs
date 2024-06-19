//
//  AnalysisViewModel.swift
//  GeneSys
//
//  Created by Eren on 13.06.2024.
//

import Foundation
import SwiftUI
import Combine

class AnalysisViewModel: ObservableObject {
    @Published var test: Test
    @Published var parameterValues: [String: String]
    private var dataManager: TestDataManager
    
    init(test: Test, dataManager: TestDataManager) {
        self.test = test
        self.parameterValues = test.parameters // Test üzerindeki kayıtlı parametre değerlerini kullanıyoruz
        self.dataManager = dataManager
    }
    
    func saveTestResults() {
        dataManager.saveTestResults(test: test, parameterValues: parameterValues)
    }
}
