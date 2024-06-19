//
//  RejectedViewModel.swift
//  GeneSys
//
//  Created by Eren on 17.06.2024.
//

import Foundation
import Combine
import SwiftUI

class RejectedViewModel: ObservableObject {
    @Published var test: [Test] = []

    private var dataManager = TestDataManager()
    private var cancellables: Set<AnyCancellable> = []

   
    
    init() {
        fetchRejectedByExpertTest()
    }
    
    func fetchRejectedByExpertTest() {
        dataManager.fetchRejectedByExpert()
        dataManager.$tests
            .sink { [weak self] test in
                self?.test = test
            }
            .store(in: &cancellables)
    }
    
    
}
