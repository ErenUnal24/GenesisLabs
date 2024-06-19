//
//  ResultAcceptedViewModel.swift
//  Deneme4
//
//  Created by Eren on 13.06.2024.
//

import Combine
import SwiftUI

class ResultAcceptedViewModel: ObservableObject {
    @Published var tests: [Test] = []
    private var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []
    @Published var searchText: String = ""


    init() {
        fetchAnalysisWaitingTests()
    }

    func fetchAnalysisWaitingTests() {
        dataManager.fetchAnalysisWaiting()
        dataManager.$tests
            .sink { [weak self] tests in
                self?.tests = tests
            }
            .store(in: &cancellables)
    }
}
