//
//  ReportWaitingViewModel.swift
//  Deneme4
//
//  Created by Eren on 14.06.2024.
//

import Combine
import SwiftUI

class ReportWaitingViewModel: ObservableObject {
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
   
}
