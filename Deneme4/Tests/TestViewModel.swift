//
//  TestViewModel.swift
//  Deneme4
//
//  Created by Eren on 11.06.2024.
//


 import SwiftUI
 import Combine

 class TestViewModel: ObservableObject {
     @Published var tests: [Test] = []
     private var dataManager = TestDataManager()
     private var cancellables = Set<AnyCancellable>()
     
     //**
     @Published var searchText: String = ""
     @Published var searchType: SearchType = .tcNo

     init() {
         dataManager.$tests
             .receive(on: DispatchQueue.main)
             .assign(to: \.tests, on: self)
             .store(in: &cancellables)
         
         fetchTests()
     }
     
     
     //**
     var filteredTests: [Test] {
             if searchText.isEmpty {
                 return tests
             } else {
                 switch searchType {
                 case .tcNo:
                     return tests.filter { $0.tcNo.contains(searchText) }
                 case .name:
                     return tests.filter { $0.patient.general.name.lowercased().contains(searchText.lowercased()) }
                 }
             }
         }
     
     
     func fetchTests() {
         dataManager.fetchSampleWaitingTests()
     }
     /*
     func add(_ tests: Test) {
         // Veritabanına ekleme işlemi burada yapılacak
         // Örnek olarak diziye ekleme işlemi:
         tests.append(tests)
     }
     
     func updatePatient(_ patient: Patient) {
             // Hasta güncelleme işlemleri
             if let index = patients.firstIndex(where: { $0.id == patient.id }) {
                 patients[index] = patient
             }
         }
     
     */
     
     
     
     
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


