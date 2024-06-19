//
//  LastListViewModel.swift
//  Deneme4
//
//  Created by Eren on 19.06.2024.
//

import Foundation


import Combine
import SwiftUI

class LastListViewModel: ObservableObject {
    @Published var tests: [Test] = []
    private var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []
    

    init() {
        fetchLastListTests()
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
