//
//  ReportedViewModel.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//




import Combine
import SwiftUI

class ReportedViewModel: ObservableObject {
    @Published var tests: [Test] = []
    @Published var rejectedTests: [Test] = []

    private var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        fetchReportedTest()
    }

    func fetchReportedTest() {
        dataManager.fetchReported()
        dataManager.$tests
            .sink { [weak self] tests in
                self?.tests = tests
            }
            .store(in: &cancellables)
    }
    
   
    
}
