//
//  ExpertViewModel.swift
//  GeneSys
//
//  Created by Eren on 15.06.2024.
//

import Foundation


import Combine
import SwiftUI

class ExpertViewModel: ObservableObject {
    @Published var tests: [Test] = []
    private var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []
    

    init() {
        fetchReportWaitingTests()
    }

    func fetchReportWaitingTests() {
        dataManager.fetchReportsWaiting()
        dataManager.$tests
            .sink { [weak self] tests in
                self?.tests = tests
            }
            .store(in: &cancellables)
    }
    
    func fetchLastListTests() {
        dataManager.fetchLastView()
        dataManager.$tests
            .sink { [weak self] tests in
                self?.tests = tests
            }
            .store(in: &cancellables)
    }
   
}
