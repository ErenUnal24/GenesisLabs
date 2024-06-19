//
//  SampleAcceptedViewModel.swift
//  GeneSys
//
//  Created by Eren on 11.06.2024.
//

import SwiftUI
import Combine

class SampleAcceptedViewModel: ObservableObject {
    @Published var tests: [Test] = []
    private var dataManager = TestDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    //**
    @Published var searchText: String = ""

    init() {
        dataManager.$tests
            .receive(on: DispatchQueue.main)
            .assign(to: \.tests, on: self)
            .store(in: &cancellables)
        
        fetchTests()
    }
    
    
    //**
//    var filteredTests: [Test] {
//            if searchText.isEmpty {
//                return tests
//            } else {
//                switch searchType {
//                case .tcNo:
//                    return tests.filter { $0.tcNo.contains(searchText) }
//                case .name:
//                    return tests.filter { $0.patient.general.name.lowercased().contains(searchText.lowercased()) }
//                }
//            }
//        }
    
    
    func fetchTests() {
        dataManager.fetchSampleAcceptedTests()
    }
   
    
    func isValid(patient: Patient) -> Bool {
            !patient.general.name.isEmpty &&
            !patient.contact.phoneNumber.isEmpty &&
            patient.contact.phoneNumber.first == "5" && // Telefon numarası 5 ile başlamalı
            patient.contact.email.hasSuffix("@mail.com")
        }
    
    
    
    //**
    enum SearchType {
            case tcNo
            case name
        }
    
}


